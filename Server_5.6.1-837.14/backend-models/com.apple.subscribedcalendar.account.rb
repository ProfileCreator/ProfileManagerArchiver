#-------------------------------------------------------------------------
# Copyright (c) 2018 Apple Inc. All rights reserved.
#
# IMPORTANT NOTE: This file is licensed only for use on Apple-branded
# computers and is subject to the terms and conditions of the Apple Software
# License Agreement accompanying the package this file is a part of.
# You may not port this file to another platform without Apple's written consent.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
class CalSubKnobSet < KnobSet
#-------------------------------------------------------------------------

  @@payload_type          = 'com.apple.subscribedcalendar.account'
  @@payload_subidentifier = 'calsub'
  @@is_unique             = false
  @@payload_name          = 'Subscribed Calendars'

  #-------------------------------------------------------------------------

  def localized_payload_display_name(short = false)
    name = I18n.t('cal_sub_display_name')
    name = sprintf(I18n.t('profile_long_display_format'), name, self.SubCalAccountDescription) unless short
    return name
  end # localized_payload_display_name

#-------------------------------------------------------------------------
end # class CalSubKnobSet
#-------------------------------------------------------------------------
