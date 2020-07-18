#
#-- Copyright (C) 2019 dz <dingzhong110@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-dnspod
PKG_VERSION:=1.15
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-dnspod
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for dnspod
	PKGARCH:=all
	DEPENDS:=+bash +curl
endef

define Package/luci-app-dnspod/description
	LuCI Support for DNSPOD DDNS.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/po/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-dnspod/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/luci-dnspod ]; then
		( . /etc/uci-defaults/luci-dnspod ) && \
		rm -f /etc/uci-defaults/luci-dnspod
	fi
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef

define Package/luci-app-dnspod/prerm
#!/bin/sh
/etc/init.d/dnspod stop
exit 0
endef

define Package/luci-app-dnspod/conffiles
/etc/config/dnspod
endef

define Package/luci-app-dnspod/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/dnspod.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/dnspod
	$(INSTALL_DATA) ./luasrc/model/cbi/*.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./root/etc/config/dnspod $(1)/etc/config/dnspod
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/dnspod $(1)/etc/init.d/dnspod
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/luci-dnspod $(1)/etc/uci-defaults/luci-dnspod
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_DIR) $(1)/usr/share/dnspod
	$(INSTALL_BIN) ./root/usr/share/dnspod/ddnspod.sh $(1)/usr/share/dnspod/ddnspod.sh
	$(INSTALL_BIN) ./root/usr/share/dnspod/dns.conf $(1)/usr/share/dnspod/dns.conf
endef

$(eval $(call BuildPackage,luci-app-dnspod))
