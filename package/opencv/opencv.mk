################################################################################
#
# opencv
#
################################################################################

OPENCV_VERSION = 2.4.10
OPENCV_SITE = $(call github,itseez,opencv,$(OPENCV_VERSION))
OPENCV_INSTALL_STAGING = YES
OPENCV_LICENSE = BSD-3c
OPENCV_LICENSE_FILES = LICENSE

# OpenCV component options
OPENCV_CONF_OPTS += \
	-DBUILD_WITH_DEBUG_INFO=OFF \
	-DBUILD_PERF_TESTS=$(if $(BR2_PACKAGE_OPENCV_BUILD_PERF_TESTS),ON,OFF) \
	-DBUILD_TESTS=$(if $(BR2_PACKAGE_OPENCV_BUILD_TESTS),ON,OFF)

# OpenCV build options
OPENCV_CONF_OPTS += \
	-DBUILD_WITH_STATIC_CRT=OFF      \
	-DENABLE_FAST_MATH=ON            \
	-DENABLE_NOISY_WARNINGS=OFF      \
	-DENABLE_OMIT_FRAME_POINTER=ON   \
	-DENABLE_PRECOMPILED_HEADERS=OFF \
	-DENABLE_PROFILING=OFF           \
	-DOPENCV_CAN_BREAK_BINARY_COMPATIBILITY=ON

# OpenCV link options
OPENCV_CONF_OPTS += \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF                  \
	-DCMAKE_USE_RELATIVE_PATHS=OFF

# OpenCV packaging options:
OPENCV_CONF_OPTS += \
	-DBUILD_PACKAGE=OFF           \
	-DENABLE_SOLUTION_FOLDERS=OFF \
	-DINSTALL_CREATE_DISTRIB=OFF

# OpenCV module selection
OPENCV_CONF_OPTS += \
	-DBUILD_opencv_androidcamera=OFF                                        \
	-DBUILD_opencv_apps=OFF                                                 \
	-DBUILD_opencv_calib3d=$(if $(BR2_PACKAGE_OPENCV_LIB_CALIB3D),ON,OFF)   \
	-DBUILD_opencv_contrib=$(if $(BR2_PACKAGE_OPENCV_LIB_CONTRIB),ON,OFF)   \
	-DBUILD_opencv_core=ON                                                  \
	-DBUILD_opencv_dynamicuda=OFF                                           \
	-DBUILD_opencv_features2d=$(if $(BR2_PACKAGE_OPENCV_LIB_FEATURES2D),ON,OFF) \
	-DBUILD_opencv_flann=$(if $(BR2_PACKAGE_OPENCV_LIB_FLANN),ON,OFF)       \
	-DBUILD_opencv_gpu=$(if $(BR2_PACKAGE_OPENCV_LIB_GPU),ON,OFF)           \
	-DBUILD_opencv_highgui=$(if $(BR2_PACKAGE_OPENCV_LIB_HIGHGUI),ON,OFF)   \
	-DBUILD_opencv_imgproc=$(if $(BR2_PACKAGE_OPENCV_LIB_IMGPROC),ON,OFF)   \
	-DBUILD_opencv_java=OFF                                                 \
	-DBUILD_opencv_legacy=$(if $(BR2_PACKAGE_OPENCV_LIB_LEGACY),ON,OFF)     \
	-DBUILD_opencv_ml=$(if $(BR2_PACKAGE_OPENCV_LIB_ML),ON,OFF)             \
	-DBUILD_opencv_nonfree=$(if $(BR2_PACKAGE_OPENCV_LIB_NONFREE),ON,OFF)   \
	-DBUILD_opencv_objdetect=$(if $(BR2_PACKAGE_OPENCV_LIB_OBJDETECT),ON,OFF) \
	-DBUILD_opencv_ocl=OFF                                                  \
	-DBUILD_opencv_photo=$(if $(BR2_PACKAGE_OPENCV_LIB_PHOTO),ON,OFF)       \
	-DBUILD_opencv_python=OFF                                               \
	-DBUILD_opencv_stitching=$(if $(BR2_PACKAGE_OPENCV_LIB_STITCHING),ON,OFF) \
	-DBUILD_opencv_superres=$(if $(BR2_PACKAGE_OPENCV_LIB_SUPERRES),ON,OFF) \
	-DBUILD_opencv_ts=$(if $(BR2_PACKAGE_OPENCV_LIB_TS),ON,OFF)             \
	-DBUILD_opencv_video=$(if $(BR2_PACKAGE_OPENCV_LIB_VIDEO),ON,OFF)       \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_world=OFF

# Hardware support options.
#
# * PowerPC support is turned off since its only effect is altering CFLAGS,
#   adding '-mcpu=G3 -mtune=G5' to them, which is already handled by Buildroot.
OPENCV_CONF_OPTS += \
	-DENABLE_POWERPC=OFF \
	-DENABLE_SSE=$(if $(BR2_X86_CPU_HAS_SSE),ON,OFF)     \
	-DENABLE_SSE2=$(if $(BR2_X86_CPU_HAS_SSE2),ON,OFF)   \
	-DENABLE_SSE3=$(if $(BR2_X86_CPU_HAS_SSE3),ON,OFF)   \
	-DENABLE_SSE41=$(if $(BR2_X86_CPU_HAS_SSE4),ON,OFF)  \
	-DENABLE_SSE42=$(if $(BR2_X86_CPU_HAS_SSE42),ON,OFF) \
	-DENABLE_SSSE3=$(if $(BR2_X86_CPU_HAS_SSSE3),ON,OFF)

# Cuda stuff
OPENCV_CONF_OPTS += \
	-DWITH_CUBLAS=OFF \
	-DWITH_CUDA=OFF   \
	-DWITH_CUFFT=OFF

# NVidia stuff
OPENCV_CONF_OPTS += -DWITH_NVCUVID=OFF

# AMD stuff
OPENCV_CONF_OPTS += \
	-DWITH_OPENCLAMDFFT=OFF \
	-DWITH_OPENCLAMDBLAS=OFF

# Intel stuff
OPENCV_CONF_OPTS += \
	-DWITH_INTELPERC=OFF \
	-DWITH_IPP=OFF       \
	-DWITH_TBB=OFF

# Smartek stuff
OPENCV_CONF_OPTS += -DWITH_GIGEAPI=OFF

# Prosilica stuff
OPENCV_CONF_OPTS += -DWITH_PVAPI=OFF

# Ximea stuff
OPENCV_CONF_OPTS += -DWITH_XIMEA=OFF

# Non-Linux support (Android options) must remain OFF:
OPENCV_CONF_OPTS += \
	-DWITH_ANDROID_CAMERA=OFF          \
	-DBUILD_ANDROID_CAMERA_WRAPPER=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF	   \
	-DINSTALL_ANDROID_EXAMPLES=OFF     \
	-DBUILD_FAT_JAVA_LIB=OFF           \
	-DBUILD_JAVA_SUPPORT=OFF

# Non-Linux support (Mac OSX options) must remain OFF:
OPENCV_CONF_OPTS += \
	-DWITH_AVFOUNDATION=OFF	\
	-DWITH_CARBON=OFF       \
	-DWITH_QUICKTIME=OFF

# Non-Linux support (Windows options) must remain OFF:
OPENCV_CONF_OPTS += \
	-DWITH_VFW=OFF      \
	-DWITH_WIN32UI=OFF  \
	-DWITH_CSTRIPES=OFF \
	-DWITH_DSHOW=OFF    \
	-DWITH_MSMF=OFF     \
	-DWITH_VIDEOINPUT=OFF

# Software/3rd-party support options.
OPENCV_CONF_OPTS += \
	-DBUILD_JASPER=OFF  \
	-DBUILD_JPEG=OFF    \
	-DBUILD_OPENEXR=OFF \
	-DBUILD_PNG=OFF	    \
	-DBUILD_TIFF=OFF    \
	-DBUILD_ZLIB=OFF    \
	-DBUILD_NEW_PYTHON_SUPPORT=OFF \
	-DINSTALL_C_EXAMPLES=OFF       \
	-DINSTALL_PYTHON_EXAMPLES=OFF  \
	-DINSTALL_TO_MANGLED_PATHS=OFF

# Disabled features (mostly because they are not available in Buildroot), but
# - eigen: OpenCV does not use it, not take any benefit from it.
OPENCV_CONF_OPTS += \
	-DWITH_1394=OFF    \
	-DWITH_EIGEN=OFF   \
	-DWITH_IMAGEIO=OFF \
	-DWITH_OPENCL=OFF  \
	-DWITH_OPENEXR=OFF \
	-DWITH_OPENGL=OFF  \
	-DWITH_OPENMP=OFF  \
	-DWITH_OPENNI=OFF  \
	-DWITH_UNICAP=OFF  \
	-DWITH_XINE=OFF

OPENCV_DEPENDENCIES += zlib

ifeq ($(BR2_PACKAGE_OPENCV_WITH_FFMPEG),y)
OPENCV_CONF_OPTS += -DWITH_FFMPEG=ON
OPENCV_DEPENDENCIES += ffmpeg bzip2
else
OPENCV_CONF_OPTS += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_GSTREAMER),y)
OPENCV_CONF_OPTS += -DWITH_GSTREAMER=ON
OPENCV_DEPENDENCIES += gstreamer gst-plugins-base
else
OPENCV_CONF_OPTS += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_GTK),y)
OPENCV_CONF_OPTS += -DWITH_GTK=ON
OPENCV_DEPENDENCIES += libgtk2
else
OPENCV_CONF_OPTS += -DWITH_GTK=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_JASPER),y)
OPENCV_CONF_OPTS += -DWITH_JASPER=ON
OPENCV_DEPENDENCIES += jasper
else
OPENCV_CONF_OPTS += -DWITH_JASPER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_JPEG),y)
OPENCV_CONF_OPTS += -DWITH_JPEG=ON
OPENCV_DEPENDENCIES += jpeg
else
OPENCV_CONF_OPTS += -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_PNG),y)
OPENCV_CONF_OPTS += -DWITH_PNG=ON
OPENCV_DEPENDENCIES += libpng
else
OPENCV_CONF_OPTS += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_QT),y)
OPENCV_CONF_OPTS += -DWITH_QT=4
OPENCV_DEPENDENCIES += qt
else
OPENCV_CONF_OPTS += -DWITH_QT=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_TIFF),y)
OPENCV_CONF_OPTS += -DWITH_TIFF=ON
OPENCV_DEPENDENCIES += tiff
else
OPENCV_CONF_OPTS += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_V4L),y)
OPENCV_CONF_OPTS += \
	-DWITH_V4L=ON \
	-DWITH_LIBV4L=$(if $(BR2_PACKAGE_LIBV4L),ON,OFF)
OPENCV_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBV4L),libv4l)
else
OPENCV_CONF_OPTS += -DWITH_V4L=OFF -DWITH_LIBV4L=OFF
endif

# Installation hooks:
define OPENCV_CLEAN_INSTALL_DOC
	$(RM) -fr $(TARGET_DIR)/usr/share/OpenCV/doc
endef
OPENCV_POST_INSTALL_TARGET_HOOKS += OPENCV_CLEAN_INSTALL_DOC

define OPENCV_CLEAN_INSTALL_CMAKE
	$(RM) -f $(TARGET_DIR)/usr/share/OpenCV/OpenCVConfig*.cmake
endef
OPENCV_POST_INSTALL_TARGET_HOOKS += OPENCV_CLEAN_INSTALL_CMAKE

ifneq ($(BR2_PACKAGE_OPENCV_INSTALL_DATA),y)
define OPENCV_CLEAN_INSTALL_DATA
	$(RM) -fr $(TARGET_DIR)/usr/share/OpenCV/haarcascades \
		$(TARGET_DIR)/usr/share/OpenCV/lbpcascades
endef
OPENCV_POST_INSTALL_TARGET_HOOKS += OPENCV_CLEAN_INSTALL_DATA
endif

$(eval $(cmake-package))
