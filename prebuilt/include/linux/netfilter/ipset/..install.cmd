cmd_usr/include/linux/netfilter/ipset/.install := /bin/sh /Volumes/android/mokee/kernel/smartisan/sdm845/scripts/headers_install.sh ./usr/include/linux/netfilter/ipset /Volumes/android/mokee/kernel/smartisan/sdm845/include/uapi/linux/netfilter/ipset ip_set.h ip_set_bitmap.h ip_set_hash.h ip_set_list.h; /bin/sh /Volumes/android/mokee/kernel/smartisan/sdm845/scripts/headers_install.sh ./usr/include/linux/netfilter/ipset /Volumes/android/mokee/kernel/smartisan/sdm845/include/linux/netfilter/ipset ; /bin/sh /Volumes/android/mokee/kernel/smartisan/sdm845/scripts/headers_install.sh ./usr/include/linux/netfilter/ipset ./include/generated/uapi/linux/netfilter/ipset ; for F in ; do echo "\#include <asm-generic/$$F>" > ./usr/include/linux/netfilter/ipset/$$F; done; touch usr/include/linux/netfilter/ipset/.install