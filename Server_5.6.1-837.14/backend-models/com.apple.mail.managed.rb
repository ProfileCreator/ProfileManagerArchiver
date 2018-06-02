#-------------------------------------------------------------------------
# Copyright (c) 2018 Apple Inc. All rights reserved.
#
# IMPORTANT NOTE: This file is licensed only for use on Apple-branded
# computers and is subject to the terms and conditions of the Apple Software
# License Agreement accompanying the package this file is a part of.
# You may not port this file to another platform without Apple's written consent.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
class EmailKnobSet < KnobSet
#-------------------------------------------------------------------------

  @@payload_type          = 'com.apple.mail.managed'
  @@payload_subidentifier = 'email'
  @@is_unique             = false
  @@payload_name          = 'Email'

  #-------------------------------------------------------------------------

  def self.dynamic_attributes_defaults
    return { self.to_s => { :disableMailRecentsSyncing => false } }
  end # self.dynamic_attributes_defaults

  #-------------------------------------------------------------------------

  def localized_payload_display_name(short = false)
    name = I18n.t(self.EmailAccountType == 'EmailTypePOP' ? 'email_pop_display_name' : 'email_imap_display_name')
    name = sprintf(I18n.t('profile_long_display_format'), name, self.EmailAccountDescription) unless short
    return name
  end # localized_payload_display_name

#-------------------------------------------------------------------------
end # class EmailKnobSet
#-------------------------------------------------------------------------
