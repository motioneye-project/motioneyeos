################################################################################
#
# optee-benchmark
#
################################################################################

OPTEE_BENCHMARK_VERSION = 3.7.0
OPTEE_BENCHMARK_SITE = $(call github,linaro-swg,optee_benchmark,$(OPTEE_BENCHMARK_VERSION))
OPTEE_BENCHMARK_LICENSE = BSD-2-Clause
OPTEE_BENCHMARK_LICENSE_FILES = LICENSE

OPTEE_BENCHMARK_DEPENDENCIES = optee-client libyaml

$(eval $(cmake-package))
