VNDK_SP_LIBRARIES := \
    android.hardware.graphics.allocator@2.0 \
    android.hardware.graphics.mapper@2.0 \
    android.hardware.graphics.common@1.0 \
    android.hardware.renderscript@1.0 \
    android.hidl.base@1.0 \
    android.hidl.memory@1.0 \
    libRSCpuRef \
    libRSDriver \
    libRS_internal \
    libbacktrace \
    libbase \
    libbcinfo \
    libblas \
    libc++ \
    libcompiler_rt \
    libcutils \
    libft2 \
    libhardware \
    libhidlbase \
    libhidlmemory \
    libhidltransport \
    libhwbinder \
    libion \
    liblzma \
    libpng \
    libunwind \
    libutils \
    libutilscallstack \
    libdexfile

EXTRA_VENDOR_LIBRARIES := \
    android.hidl.base@1.0 \
    com.qualcomm.qti.imscmservice@1.0 \
    com.qualcomm.qti.imscmservice@2.0 \
    com.qualcomm.qti.imscmservice@2.1 \
    com.qualcomm.qti.uceservice@2.0 \
    vendor.display.config@1.0 \
    vendor.display.config@1.1 \
    vendor.mokee.livedisplay@2.0 \
    vendor.mokee.power@1.0 \
    vendor.mokee.trust@1.0 \
    vendor.nxp.hardware.nfc@1.0 \
    vendor.qti.hardware.camera.device@1.0 \
    vendor.qti.hardware.data.dynamicdds@1.0 \
    vendor.qti.hardware.data.latency@1.0 \
    vendor.qti.ims.rcsconfig@1.0 \
    vendor.qti.imsrtpservice@1.0 \
    vendor.qti.latency@2.0

EXTRA_VENDOR_LIBRARIES += \
    libqmi_cci_system
