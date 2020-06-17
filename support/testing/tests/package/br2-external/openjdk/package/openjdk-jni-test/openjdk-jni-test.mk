################################################################################
#
# openjdk jni test
#
################################################################################

OPENJDK_JNI_TEST_DEPENDENCIES = openjdk

JNI_INCLUDE_PATH = $(BUILD_DIR)/openjdk-$(OPENJDK_VERSION)/build/linux-aarch64-server-release/jdk/include

define OPENJDK_JNI_TEST_BUILD_CMDS
	# Compile Java classes and generate native headers
	$(JAVAC) -d $(@D) -h $(@D) \
		$(OPENJDK_JNI_TEST_PKGDIR)/JniTest.java \
		$(OPENJDK_JNI_TEST_PKGDIR)/JniWrapper.java \
		$(OPENJDK_JNI_TEST_PKGDIR)/JniHelper.java

	# Compile shared library
	$(TARGET_MAKE_ENV) $(TARGET_CC) -shared -fPIC \
		-I$(JNI_INCLUDE_PATH) -I$(JNI_INCLUDE_PATH)/linux -I$(@D) \
		-o $(@D)/libjni_native.so \
		$(OPENJDK_JNI_TEST_PKGDIR)/JniWrapper.c \
		$(OPENJDK_JNI_TEST_PKGDIR)/jni_helper.c \
		$(OPENJDK_JNI_TEST_PKGDIR)/native.c
endef

define OPENJDK_JNI_TEST_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/JniTest.class $(TARGET_DIR)/usr/bin/JniTest.class
	$(INSTALL) -D -m 755 $(@D)/JniWrapper.class $(TARGET_DIR)/usr/bin/JniWrapper.class
	$(INSTALL) -D -m 755 $(@D)/JniHelper.class $(TARGET_DIR)/usr/bin/JniHelper.class
	$(INSTALL) -D -m 755 $(@D)/libjni_native.so $(TARGET_DIR)/usr/lib/libjni_native.so
endef

$(eval $(generic-package))
