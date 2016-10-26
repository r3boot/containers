package main

import (
	"bufio"
	"flag"
	"github.com/r3boot/rlib/logger"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

const D_DEBUG bool = false
const D_METRICS_SINK string = "http://localhost:8086"
const D_ETCD_ENDPOINT string = "http://localhost:2379"
const D_INTERVAL int = 15

const D_CHAN_MAX int = 5

var f_debug = flag.Bool("D", D_DEBUG, "Enable debugging output")
var f_metrics_sink = flag.String("sink", D_METRICS_SINK, "Influxdb endpoint")
var f_etcd_endpoint = flag.String("etcd", D_ETCD_ENDPOINT, "Etcd endpoint")
var f_interval = flag.Int("i", D_INTERVAL, "Interval between metrics captures")

var debug bool
var metrics_sink string
var etcd_endpoint string
var interval int
var hostname string

var Log logger.Log

func parseOpt(param interface{}, env interface{}, def_val interface{}) (r interface{}) {
	r = param
	if param == def_val && env != "" {
		r = env
	}

	return
}

func metricsReader(read_chan chan []string) {
	var client *http.Client
	var resp *http.Response
	var reader *bufio.Scanner
	var metrics_url string
	var line string
	var lines []string
	var err error
	var t_start int64
	var t_end int64
	var t_elapsed time.Duration
	var t_interval time.Duration

	client = &http.Client{}
	t_interval = time.Duration(interval)

	for {
		t_start = time.Now().Unix()

		if resp, err = client.Get(etcd_endpoint); err != nil {
			Log.Warning("Failed to read from " + metrics_url + ": " + err.Error())
			time.Sleep(time.Duration(interval) * time.Second)
			continue
		}
		defer resp.Body.Close()
		Log.Debug("Got metric from " + etcd_endpoint)

		reader = bufio.NewScanner(resp.Body)

		lines = make([]string, D_CHAN_MAX)
		for reader.Scan() {
			line = strings.TrimSpace(reader.Text())

			// Skip comment lines
			if strings.HasPrefix(line, "#") {
				continue
			} else if line == "\n" {
				continue
			}
			lines = append(lines, line)
		}

		read_chan <- lines

		t_end = time.Now().Unix()
		t_elapsed = time.Duration(t_end - t_start)
		if t_elapsed < t_interval {
			time.Sleep((t_interval - t_elapsed) * time.Second)
		}
	}
}

func parseAndConvert(read_chan chan []string, write_chan chan string) {
	var lines []string
	var tokens []string
	var line string
	var key string
	var value string
	var metrics string
	var metric string
	var additional string
	var timestamp string
	var subtoken_s string
	var subtokens []string
	var stoken string
	var k_sub []string

	lines = make([]string, D_CHAN_MAX)

	for {
		lines = <-read_chan
		timestamp = strconv.FormatInt(time.Now().UnixNano(), 10)
		for _, line = range lines {
			if line == "" {
				continue
			}

			tokens = strings.Split(line, " ")

			if len(tokens) == 0 {
				continue
			}

			value = tokens[1]
			if value == "NaN" {
				value = "0"
			}

			additional = ""
			if strings.Contains(tokens[0], "{") {
				k_sub = strings.Split(tokens[0], "{")
				key = k_sub[0]
				subtoken_s = k_sub[1]

				subtoken_s = strings.Split(subtoken_s, "}")[0]
				subtokens = strings.Split(subtoken_s, ",")
				for _, stoken = range subtokens {
					if strings.HasPrefix(stoken, "handler") {
						continue
					}
					additional = additional + "," + stoken
				}
			} else {
				key = tokens[0]
			}

			metric = key + additional + ",host=" + hostname
			metric = metric + " value=" + value + " " + timestamp + "\n"

			metrics = metrics + metric
		}

		write_chan <- metrics
	}
}

func metricsWriter(write_chan chan string) {
	var client *http.Client
	var metrics string
	var resp *http.Response
	var err error
	var body_b []byte

	client = &http.Client{}

	for {
		metrics = <-write_chan

		if resp, err = client.Post(metrics_sink, "application/octet-stream", strings.NewReader(metrics)); err != nil {
			Log.Warning("Http post failed: " + err.Error())
			return
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusNoContent {
			Log.Warning("Failed to post metrics to " + metrics_sink + ": " + resp.Status)
			if body_b, err = ioutil.ReadAll(resp.Body); err != nil {
				Log.Warning("Failed to parse body: " + err.Error())
			}
			Log.Warning(string(body_b))
		}
		Log.Debug("Wrote metric to " + metrics_sink)
	}
}

func init() {
	flag.Parse()

	debug = *f_debug
	interval = *f_interval
	metrics_sink = parseOpt(*f_metrics_sink,
		os.Getenv("METRICS_SINK"), D_METRICS_SINK).(string)
	etcd_endpoint = parseOpt(*f_etcd_endpoint,
		os.Getenv("ETCD_ENDPOINT"), D_ETCD_ENDPOINT).(string)
	etcd_endpoint += "/metrics"
	metrics_sink += "/write?db=etcd"

	hostname = os.Getenv("HOSTNAME")
	if hostname == "" {
		hostname = "HOSTNAME-NOT-SET"
	}

	Log.UseDebug = debug
	Log.UseVerbose = debug
	Log.UseTimestamp = false
	Log.Debug("Logging initialized")

	Log.Debug("Using " + hostname + " as hostname")
	Log.Debug("Reporting metrics for " + etcd_endpoint)
	Log.Info("Sending metrics to " + metrics_sink)
}

func main() {
	var metrics_from_reader chan []string
	var metrics_to_writer chan string

	metrics_from_reader = make(chan []string, D_CHAN_MAX)
	metrics_to_writer = make(chan string, D_CHAN_MAX)

	go metricsReader(metrics_from_reader)
	go parseAndConvert(metrics_from_reader, metrics_to_writer)
	metricsWriter(metrics_to_writer)
}
