test_that("create", {
  el <- event_loop$new()
  expect_s3_class(el, "event_loop")
})

test_that("next tick", {
  el <- event_loop$new()

  ticked <- FALSE
  error <- "foo"
  result <- "bar"
  el$add_next_tick(
    function() ticked <<- TRUE,
    function(err, res) {
      error <<- err
      result <<- res
    }
  )
  el$run()

  expect_true(ticked)
  expect_null(error)
  expect_true(result)
})

test_that("event loop with only timers sleeps", {
  tim <- system.time(synchronise(delay(1 / 2)))
  expect_true(tim[[1]] + tim[[2]] < 0.4)
  expect_true(tim[[3]] >= 0.4)
})

test_that("repeated delay", {
  counter <- 0
  error <- "foo"
  result <- numeric()

  el <- event_loop$new()
  id <- el$add_delayed(
    0.1,
    function() {
      counter <<- counter + 1
      if (counter == 10) el$cancel(id)
      counter
    },
    function(err, res) {
      error <<- err
      result <<- c(result, res)
    },
    rep = TRUE
  )

  start <- Sys.time()
  el$run()
  end <- Sys.time()

  expect_equal(counter, 10)
  expect_null(error)
  expect_equal(result, 1:10)
  expect_true(end - start >= as.difftime(1, units = "secs"))
  expect_true(end - start <= as.difftime(3, units = "secs"))
})

test_that("nested event loops", {
  ## Create a function that finishes while its event loop is inactive
  afun1 <- function(x) {
    x
    async_constant(x)
  }
  afun2 <- function(x1, x2) {
    x1
    x2
    p1 <- afun1(x1)
    p2 <- delay(0)$then(function() synchronise(afun1(x2)))
    when_all(p1, p2)
  }

  res <- synchronise(afun2(1, 2))
  expect_equal(res, list(1, 2))
})
