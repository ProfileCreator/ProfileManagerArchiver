#-------------------------------------------------------------------------
# Copyright (c) 2018 Apple Inc. All rights reserved.
#
# IMPORTANT NOTE: This file is licensed only for use on Apple-branded
# computers and is subject to the terms and conditions of the Apple Software
# License Agreement accompanying the package this file is a part of.
# You may not port this file to another platform without Apple's written consent.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
class ProxiesKnobSet < KnobSet
#-------------------------------------------------------------------------

  @@payload_type          = 'com.apple.SystemConfiguration'
  @@payload_subidentifier = 'proxies'
  @@is_unique             = false
  @@payload_name          = 'Proxies'

  #-------------------------------------------------------------------------

  def localized_payload_display_name(short = false);  return I18n.t('proxies_display_name');  end

#-------------------------------------------------------------------------
end # class ProxiesKnobSet
#-------------------------------------------------------------------------
