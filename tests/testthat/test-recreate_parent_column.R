test_that("recreate other columns", {
  ####### sm_seperator = "." single "."

  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  # expected result
  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "xx zy",
      "zy", "xx xz zy",
      "yy", "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  ### apply function
  testthat::expect_no_warning(recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "."))
  actual_result <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = ".")

  testthat::expect_equal(actual_result$data_with_fix_concat, expected_test)


  ####### sm_seperator = "." multiple "."


  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.x.x. = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.x.z = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "x_x_ zy",
      "zy", "x_x_ x_z zy",
      "yy", "x_z"
    ),
    reason.x_x_ = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.x_z = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  actual_result <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = ".") %>%
    suppressWarnings()

  testthat::expect_equal(actual_result$data_with_fix_concat, expected_test)
  testthat::expect_warning(recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "."))


  ####### check sm_seperator = "/" mix with "."


  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x. yy", "x.x. zy",
      "zy", "x.x. x.z zy",
      NA_character_, "x.z"
    ),
    `reason/x.x.` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/zy` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "x.x. zy",
      "zy", "x.x. x.z zy",
      "yy", "x.z"
    ),
    `reason/x.x.` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/zy` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  actual_result <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "/")

  testthat::expect_equal(actual_result$data_with_fix_concat, expected_test)



  ####### sm_seperator = "/"with multiple "/"


  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x. yy", "x.x. zy",
      "zy", "x.x. x.z zy",
      NA_character_, "x.z"
    ),
    `reason/x.x/` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/z/y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "x.x_ z_y",
      "z_y", "x.x_ x.z z_y",
      "yy", "x.z"
    ),
    `reason/x.x_` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/z_y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  testthat::expect_warning(recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "/"))
  actual_result <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "/") %>%
    suppressWarnings()

  testthat::expect_equal(actual_result$data_with_fix_concat, expected_test)



  ##### Check with KObo

  survey_sheet <- dplyr::tibble(
    type = "select_multiple xxx",
    name = "reason"
  )
  choice_sheet <- dplyr::tibble(
    list_name = c("xxx", "xxx", "xxx", "xxx"),
    name = c("x/x", "y.y", "xz", "z_y")
  )

  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x/x y.y", "x/x z_y",
      "z_y", "x/x xz z_y",
      NA_character_, "xz"
    ),
    `reason/x/x` = c(0, 1, 0, 1, 0, 0),
    `reason/y.y` = c(1, 0, 0, 0, 1, 0),
    `reason/xz` = c(0, 0, 0, 1, 0, 1),
    `reason/z_y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  expected_result <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "y.y", "x/x z_y",
      "z_y", "x/x xz z_y",
      "y.y", "xz"
    ),
    `reason/x/x` = c(0, 1, 0, 1, 0, 0),
    `reason/y.y` = c(1, 0, 0, 0, 1, 0),
    `reason/xz` = c(0, 0, 0, 1, 0, 1),
    `reason/z_y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  actual_result <- recreate_parent_column(
    dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "/",
    kobo_survey = survey_sheet,
    kobo_choices = choice_sheet
  )

  testthat::expect_equal(expected_result, actual_result$data_with_fix_concat)

  ### check error message
  choice_sheet <- dplyr::tibble(
    list_name = c("xxx", "xxx", "xxx", "xxx"),
    name = c("x/x", "y.y", "xz", "x_y")
  ) ## checking missing column
  testthat::expect_warning(recreate_parent_column(
    dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = "/",
    kobo_survey = survey_sheet,
    kobo_choices = choice_sheet
  ))


  ### check with several changes in one line
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 1, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 1, 1),
    reason.zy = c(0, 1, 1, 1, 1, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )
  # expected result
  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "xx zy",
      "zy", "xx xz zy",
      "xx yy xz zy", "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 1, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 1, 1),
    reason.zy = c(0, 1, 1, 1, 1, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  actual_output <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = ".")
  expect_equal(expected_test, actual_output$data_with_fix_concat)

  ### check with adding one option (line3) and swapping options (line 6)
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 1, 0),
    reason.yy = c(1, 0, 1, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 1, 0),
    reason.zy = c(0, 1, 1, 1, 1, 1),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )
  # expected result
  expected_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "xx zy",
      "yy zy", "xx xz zy",
      "xx yy xz zy", "zy"
    ),
    reason.xx = c(0, 1, 0, 1, 1, 0),
    reason.yy = c(1, 0, 1, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 1, 0),
    reason.zy = c(0, 1, 1, 1, 1, 1),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  actual_output <- recreate_parent_column(dataset = pre_clean_test, uuid_column = "uuid", sm_seperator = ".")
  expect_equal(expected_test, actual_output$data_with_fix_concat)
})

test_that("auto_detect_sm_parents detects correclty", {
  ####### sm_seperator = "." single "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expect_equal(auto_detect_sm_parents(dataset = pre_clean_test), "reason")

  ####### sm_seperator = "." multiple "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.x.x. = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.x.z = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expect_equal(auto_detect_sm_parents(dataset = pre_clean_test), "reason")

  ####### check sm_seperator = "/" mix with "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x.,yy", "x.x.,zy",
      "zy", "x.x.,x.z,zy",
      NA_character_, "x.z"
    ),
    `reason/x.x.` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/zy` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expect_equal(auto_detect_sm_parents(dataset = pre_clean_test, sm_seperator = "/"), "reason")

  ####### sm_seperator = "/"with multiple "/"
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x.,yy", "x.x.,zy",
      "zy", "x.x.,x.z,zy",
      NA_character_, "x.z"
    ),
    `reason/x.x/` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/z/y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expect_equal(auto_detect_sm_parents(dataset = pre_clean_test, sm_seperator = "/"), "reason")
})

test_that("auto_sm_parent_children detects correclty", {
  ####### sm_seperator = "." single "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.xx = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.xz = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expected_results <- data.frame(
    sm_parent = rep("reason", 4),
    sm_child = c("reason.xx", "reason.yy", "reason.xz", "reason.zy")
  )

  expect_equal(auto_sm_parent_children(dataset = pre_clean_test), expected_results, ignore_attr = TRUE)

  ####### sm_seperator = "." multiple "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "xx yy", "xx zy",
      "zy", "xx xz zy",
      NA_character_, "xz"
    ),
    reason.x.x. = c(0, 1, 0, 1, 0, 0),
    reason.yy = c(1, 0, 0, 0, 1, 0),
    reason.x.z = c(0, 0, 0, 1, 0, 1),
    reason.zy = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expected_results <- data.frame(
    sm_parent = c("reason.x.x", "reason", "reason.x", "reason"),
    sm_child = c("reason.x.x.", "reason.yy", "reason.x.z", "reason.zy")
  )

  expect_equal(auto_sm_parent_children(dataset = pre_clean_test), expected_results, ignore_attr = TRUE)

  ####### check sm_seperator = "/" mix with "."
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x.,yy", "x.x.,zy",
      "zy", "x.x.,x.z,zy",
      NA_character_, "x.z"
    ),
    `reason/x.x.` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/zy` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expected_results <- data.frame(
    sm_parent = rep("reason", 4),
    sm_child = c("reason/x.x.", "reason/yy", "reason/x.z", "reason/zy")
  )

  expect_equal(auto_sm_parent_children(dataset = pre_clean_test, sm_seperator = "/"), expected_results, ignore_attr = TRUE)

  ####### sm_seperator = "/"with multiple "/"
  pre_clean_test <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "x.x.,yy", "x.x.,zy",
      "zy", "x.x.,x.z,zy",
      NA_character_, "x.z"
    ),
    `reason/x.x/` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/z/y` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )

  expected_results <- data.frame(
    sm_parent = c("reason/x.x", "reason", "reason", "reason/z"),
    sm_child = c("reason/x.x/", "reason/yy", "reason/x.z", "reason/z/y")
  )

  expect_equal(auto_sm_parent_children(dataset = pre_clean_test, sm_seperator = "/"), expected_results, ignore_attr = TRUE)
})



##### no change

test_that("recreate other columns/with no change", {
  test_data <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason = c(
      "yy", "x.x. zy",
      "zy", "x.x. x.z zy",
      "yy", "x.z"
    ),
    `reason/x.x.` = c(0, 1, 0, 1, 0, 0),
    `reason/yy` = c(1, 0, 0, 0, 1, 0),
    `reason/x.z` = c(0, 0, 0, 1, 0, 1),
    `reason/zy` = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  actual_result <- recreate_parent_column(dataset = test_data, uuid_column = "uuid", sm_seperator = "/")

  expected <- structure(list(), class = c("tbl_df", "tbl", "data.frame"), row.names = integer(0), names = character(0))

  ## check if its list
  testthat::expect_equal(length(actual_result), 2)
  testthat::expect_equal(actual_result$change_log, expected)
  testthat::expect_equal(actual_result$data_with_fix_concat, test_data)
})



##### no choice multiple

test_that("recreate other columns/with no choice multiple", {
  test_data <- dplyr::tibble(
    uuid = paste0("uuid_", 1:6),
    gender = rep(c("male", "female"), 3),
    reason1 = c(0, 1, 0, 1, 0, 0),
    reason2 = c(1, 0, 0, 0, 1, 0),
    reason3 = c(0, 0, 0, 1, 0, 1),
    reaso3 = c(0, 1, 1, 1, 0, 0),
    reason_zy = c(NA_character_, "A", "B", "C", NA_character_, NA_character_)
  )


  actual_result <- recreate_parent_column(dataset = test_data, uuid_column = "uuid", sm_seperator = "/")

  expected <- structure(list(), class = c("tbl_df", "tbl", "data.frame"), row.names = integer(0), names = character(0))

  ## check if its list
  testthat::expect_equal(length(actual_result), 2)
  testthat::expect_equal(actual_result$change_log, "No choice multiple questions/Nothing has changed")
  testthat::expect_equal(actual_result$data_with_fix_concat, test_data)
})
