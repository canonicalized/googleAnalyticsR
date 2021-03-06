% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ga_v4_get.R
\name{google_analytics}
\alias{google_analytics}
\alias{google_analytics_4}
\title{Get Google Analytics v4 data}
\usage{
google_analytics(viewId, date_range = NULL, metrics = NULL,
  dimensions = NULL, dim_filters = NULL, met_filters = NULL,
  filtersExpression = NULL, order = NULL, segments = NULL,
  pivots = NULL, cohorts = NULL, max = 1000,
  samplingLevel = c("DEFAULT", "SMALL", "LARGE"), metricFormat = NULL,
  histogramBuckets = NULL, anti_sample = FALSE,
  anti_sample_batches = "auto", slow_fetch = FALSE,
  useResourceQuotas = NULL, rows_per_call = 10000L)

google_analytics_4(...)
}
\arguments{
\item{viewId}{viewId of data to get.}

\item{date_range}{character or date vector of format \code{c(start, end)} or 
for two date ranges: \code{c(start1,end1,start2,end2)}}

\item{metrics}{Metric(s) to fetch as a character vector.  You do not need to 
supply the \code{"ga:"} prefix.  See \link{meta} for a list of dimensons 
and metrics the API supports. Also supports your own calculated metrics.}

\item{dimensions}{Dimension(s) to fetch as a character vector. You do not need to 
supply the \code{"ga:"} prefix. See \link{meta} for a list of dimensons 
and metrics the API supports.}

\item{dim_filters}{A \link{filter_clause_ga4} wrapping \link{dim_filter}}

\item{met_filters}{A \link{filter_clause_ga4} wrapping \link{met_filter}}

\item{filtersExpression}{A v3 API style simple filter string. Not used with other filters.}

\item{order}{An \link{order_type} object}

\item{segments}{List of segments as created by \link{segment_ga4}}

\item{pivots}{Pivots of the data as created by \link{pivot_ga4}}

\item{cohorts}{Cohorts created by \link{make_cohort_group}}

\item{max}{Maximum number of rows to fetch. Defaults at 1000. Use -1 to fetch all results. Ignored when \code{anti_sample=TRUE}.}

\item{samplingLevel}{Sample level}

\item{metricFormat}{If supplying calculated metrics, specify the metric type}

\item{histogramBuckets}{For numeric dimensions such as hour, a list of buckets of data.
See details in \link{make_ga_4_req}}

\item{anti_sample}{If TRUE will split up the call to avoid sampling.}

\item{anti_sample_batches}{"auto" default, or set to number of days per batch. 1 = daily.}

\item{slow_fetch}{For large, complicated API requests this bypasses some API hacks that may result in 500 errors.  For smaller queries, leave this as \code{FALSE} for quicker data fetching.}

\item{useResourceQuotas}{If using GA360, access increased sampling limits. 
Default \code{NULL}, set to \code{TRUE} or \code{FALSE} if you have access to this feature.}

\item{rows_per_call}{Set how many rows are requested by the API per call, up to a maximum of 100000.}

\item{...}{Arguments passed to \link{google_analytics}}
}
\value{
A Google Analytics data.frame, with attributes showing row totals, sampling etc.
}
\description{
Fetch Google Analytics data using the v4 API.  For the v3 API use \link{google_analytics_3}.  See website help for lots of examples: \href{http://code.markedmondson.me/googleAnalyticsR/articles/v4.html}{Google Analytics Reporting API v4 in R}
}
\section{Row requests}{


By default the API call will use v4 batching that splits requests into 5 separate calls of 10k rows each.  This can go up to 100k, so this means up to 500k rows can be fetched per API call, however the API servers will fail with a 500 error if the query is too complicated as the processing time at Google's end gets too long.  In this case, you may want to tweak the \code{rows_per_call} argument downwards, or fall back to using \code{slow_fetch = FALSE} which will send an API request one at a time.  If fetching data via scheduled scripts this is recommended as the default.
}

\section{Anti-sampling}{


\code{anti_sample} being TRUE ignores \code{max} as the API call is split over days 
  to mitigate the sampling session limit, in which case a row limit won't work.  Take the top rows
  of the result yourself instead e.g. \code{head(ga_data_unsampled, 50300)}
  
\code{anti_sample} being TRUE will also set \code{samplingLevel='LARGE'} to minimise 
  the number of calls.
}

\section{Resource Quotas}{


If you are on GA360 and have access to resource quotas,
  set the \code{useResourceQuotas=TRUE} and set the Google Cloud 
  client ID to the project that has resource quotas activated, 
  via \link[googleAuthR]{gar_set_client} or options.
}

\section{Caching}{


By default local caching is turned on for v4 API requests.  This means that
  making the same request as one this session will read from memory and not
  make an API call. You can also set the cache to disk via 
  the \link[googleAuthR]{gar_cache_setup} function.  This can be useful
  when running RMarkdown reports using data. To empty the cache use 
  \link[googleAuthR]{gar_cache_empty}.
}

\examples{

\dontrun{
library(googleAnalyticsR)

## authenticate, or use the RStudio Addin "Google API Auth" with analytics scopes set

ga_auth()

## get your accounts

account_list <- ga_account_list()

## account_list will have a column called "viewId"
account_list$viewId

## View account_list and pick the viewId you want to extract data from
ga_id <- 123456

# examine the meta table to see metrics and dimensions you can query
meta

## simple query to test connection
google_analytics(ga_id, 
                 date_range = c("2017-01-01", "2017-03-01"), 
                 metrics = "sessions", 
                 dimensions = "date")

}

}
\seealso{
Other GAv4 fetch functions: \code{\link{fetch_google_analytics_4_slow}},
  \code{\link{fetch_google_analytics_4}},
  \code{\link{make_ga_4_req}}
}
