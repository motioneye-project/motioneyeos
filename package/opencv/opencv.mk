################################################################################
#
# opencv
#
################################################################################

OPENCV_VERSION = 2.4.2
OPENCV_SITE    = http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/$(OPENCV_VERSION)
OPENCV_SOURCE  = OpenCV-$(OPENCV_VERSION).tar.bz2
OPENCV_INSTALL_STAGING = YES

OPENCV_CONF_OPT += \
	-DCMAKE_BUILD_TYPE=$(if $(BR2_ENABLE_DEBUG),Debug,Release)   \
	-DBUILD_SHARED_LIBS=$(if $(BR2_PREFER_STATIC_LIB),OFF,ON)    \
	-DBUILD_WITH_STATIC_CRT=OFF                                  \
	-DBUILD_DOCS=$(if $(BR2_HAVE_DOCUMENTATION),ON,OFF)          \
	-DBUILD_EXAMPLES=OFF                                         \
	-DBUILD_PACKAGE=OFF                                          \
	-DBUILD_TESTS=$(if $(BR2_PACKAGE_OPENCV_BUILD_TESTS),ON,OFF) \
	-DBUILD_PERF_TESTS=$(if $(BR2_PACKAGE_OPENCV_BUILD_PERF_TESTS),ON,OFF) \
	-DBUILD_WITH_DEBUG_INFO=OFF             \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF                  \
	-DCMAKE_USE_RELATIVE_PATHS=OFF          \
	-DENABLE_FAST_MATH=ON                   \
	-DENABLE_NOISY_WARNINGS=OFF             \
	-DENABLE_OMIT_FRAME_POINTER=ON          \
	-DENABLE_PRECOMPILED_HEADERS=OFF        \
	-DENABLE_PROFILING=OFF                  \
	-DENABLE_SOLUTION_FOLDERS=OFF           \
	-DOPENCV_CAN_BREAK_BINARY_COMPATIBILITY=ON

# OpenCV module selection
OPENCV_CONF_OPT += \
	-DBUILD_opencv_androidcamera=OFF                                        \
	-DBUILD_opencv_calib3d=$(if $(BR2_PACKAGE_OPENCV_LIB_CALIB3D),ON,OFF)   \
	-DBUILD_opencv_contrib=$(if $(BR2_PACKAGE_OPENCV_LIB_CONTRIB),ON,OFF)   \
	-DBUILD_opencv_core=$(if $(BR2_PACKAGE_OPENCV_LIB_CORE),ON,OFF)         \
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
	-DBUILD_opencv_photo=$(if $(BR2_PACKAGE_OPENCV_LIB_PHOTO),ON,OFF)       \
	-DBUILD_opencv_python=OFF                                               \
	-DBUILD_opencv_stitching=$(if $(BR2_PACKAGE_OPENCV_LIB_STITCHING),ON,OFF) \
	-DBUILD_opencv_ts=$(if $(BR2_PACKAGE_OPENCV_LIB_TS),ON,OFF)             \
	-DBUILD_opencv_video=$(if $(BR2_PACKAGE_OPENCV_LIB_VIDEO),ON,OFF)       \
	-DBUILD_opencv_videostab=$(if $(BR2_PACKAGE_OPENCV_LIB_VIDEOSTAB),ON,OFF) \
	-DBUILD_opencv_world=OFF

# Hardware support options.
#
# * PowerPC support is turned off since its only effect is altering CFLAGS,
#   adding '-mcpu=G3 -mtune=G5' to them, which is already handled by Buildroot.
OPENCV_CONF_OPT += \
	-DENABLE_POWERPC=OFF \
	-DENABLE_SSE=$(if $(BR2_X86_CPU_HAS_SSE),ON,OFF)     \
	-DENABLE_SSE2=$(if $(BR2_X86_CPU_HAS_SSE2),ON,OFF)   \
	-DENABLE_SSE3=$(if $(BR2_X86_CPU_HAS_SSE3),ON,OFF)   \
	-DENABLE_SSSE3=$(if $(BR2_X86_CPU_HAS_SSSE3),ON,OFF)

# Software/3rd-party support options.
OPENCV_CONF_OPT += \
	-DBUILD_JASPER=OFF \
	-DBUILD_JPEG=OFF   \
	-DBUILD_PNG=OFF	   \
	-DBUILD_TIFF=OFF   \
	-DBUILD_ZLIB=OFF   \
	-DBUILD_ANDROID_CAMERA_WRAPPER=OFF \
	-DBUILD_ANDROID_EXAMPLES=OFF	   \
	-DBUILD_FAT_JAVA_LIB=OFF           \
	-DBUILD_JAVA_SUPPORT=OFF	   \
	-DBUILD_NEW_PYTHON_SUPPORT=OFF \
	-DINSTALL_ANDROID_EXAMPLES=OFF \
	-DINSTALL_C_EXAMPLES=OFF       \
	-DINSTALL_PYTHON_EXAMPLES=OFF  \
	-DINSTALL_TO_MANGLED_PATHS=OFF \
	-DWITH_1394=OFF           \
	-DWITH_ANDROID_CAMERA=OFF \
	-DWITH_AVFOUNDATION=OFF	  \
	-DWITH_CARBON=OFF         \
	-DWITH_CUBLAS=OFF         \
	-DWITH_CUDA=OFF           \
	-DWITH_CUFFT=OFF          \
	-DWITH_EIGEN=OFF          \
	-DWITH_IMAGEIO=OFF        \
	-DWITH_IPP=OFF            \
	-DWITH_JASPER=OFF         \
	-DWITH_OPENEXR=OFF        \
	-DWITH_OPENGL=OFF         \
	-DWITH_OPENNI=OFF         \
	-DWITH_PVAPI=OFF          \
	-DWITH_QUICKTIME=OFF      \
	-DWITH_TBB=OFF            \
	-DWITH_UNICAP=OFF         \
	-DWITH_VIDEOINPUT=OFF     \
	-DWITH_XIMEA=OFF          \
	-DWITH_XINE=OFF

OPENCV_DEPENDENCIES += zlib

ifeq ($(BR2_PACKAGE_OPENCV_WITH_FFMPEG),y)
OPENCV_CONF_OPT += -DWITH_FFMPEG=ON
OPENCV_DEPENDENCIES += ffmpeg bzip2
else
OPENCV_CONF_OPT += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_GSTREAMER),y)
OPENCV_CONF_OPT += -DWITH_GSTREAMER=ON
OPENCV_DEPENDENCIES += gstreamer gst-plugins-base
else
OPENCV_CONF_OPT += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_GTK),y)
OPENCV_CONF_OPT += -DWITH_GTK=ON
OPENCV_DEPENDENCIES += libgtk2
else
OPENCV_CONF_OPT += -DWITH_GTK=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_JPEG),y)
OPENCV_CONF_OPT += -DWITH_JPEG=ON
OPENCV_DEPENDENCIES += jpeg
else
OPENCV_CONF_OPT += -DWITH_JPEG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_PNG),y)
OPENCV_CONF_OPT += -DWITH_PNG=ON
OPENCV_DEPENDENCIES += libpng
else
OPENCV_CONF_OPT += -DWITH_PNG=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_QT),y)
OPENCV_CONF_OPT += -DWITH_QT=ON
OPENCV_DEPENDENCIES += qt
else
OPENCV_CONF_OPT += -DWITH_QT=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_TIFF),y)
OPENCV_CONF_OPT += -DWITH_TIFF=ON
OPENCV_DEPENDENCIES += tiff
else
OPENCV_CONF_OPT += -DWITH_TIFF=OFF
endif

ifeq ($(BR2_PACKAGE_OPENCV_WITH_V4L),y)
OPENCV_CONF_OPT += -DWITH_V4L=ON
OPENCV_DEPENDENCIES += libv4l
else
OPENCV_CONF_OPT += -DWITH_V4L=OFF
endif

# Installation hooks:
ifneq ($(BR2_HAVE_DOCUMENTATION),y)
define OPENCV_CLEAN_INSTALL_DOC
	$(RM) -fr $(TARGET_DIR)/usr/share/OpenCV/doc
endef
OPENCV_POST_INSTALL_TARGET_HOOKS += OPENCV_CLEAN_INSTALL_DOC
endif

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
