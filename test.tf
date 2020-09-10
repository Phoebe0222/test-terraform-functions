provider "google" {
  version = "~> 3.35.0"
}

variable "test_prefix" {
  default = "some_string"
}

variable "test_user_list" {
  default = ["phoebe@mlsa.com", "test_user@mlsa.com"]
}

locals {
  test_group_list = [var.test_prefix == "some_string" ? "some_group@mlsa.com" : ""]
}

locals {
  object_list = [
    {
      role   =   "OWNER"
      group_by_email   =   "owner@mlsa.com"
    },
    {
      role   =   "WRITER"
      group_by_email   =   "editor@mlsa.com"
    },
    # var.test_prefix == "some_string" ? jsonencode(map("role", "READER", "group_by_email", "reader@mlsa.com")) : jsonencode({})
    ]
}

data "null_data_source" "test_user_data" {
  count = length(var.test_user_list)
  inputs = {
    role   =   "READER"
    user_by_email   =   var.test_user_list[count.index]
  }
}

data "null_data_source" "test_group_data" {
  count = length(compact(local.test_group_list))
  inputs = {
    role   =   "READER"
    user_by_email   =   local.test_group_list[0]
  }
}

## test functions
resource "google_bigquery_dataset" "dataset" {
  dataset_id   =   "example_dataset"
  dynamic "access" {
    for_each = concat(
      local.object_list,
      data.null_data_source.test_user_data.*.outputs,
      data.null_data_source.test_group_data.*.outputs,
    )
    content {
      role             = lookup(access.value, "role", null)
      group_by_email   = lookup(access.value, "group_by_email", null)
      user_by_email    = lookup(access.value, "user_by_email", null)
    }
  }
}