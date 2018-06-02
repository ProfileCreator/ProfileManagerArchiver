#-------------------------------------------------------------------------
# Copyright (c) 2018 Apple Inc. All rights reserved.
#
# IMPORTANT NOTE: This file is licensed only for use on Apple-branded
# computers and is subject to the terms and conditions of the Apple Software
# License Agreement accompanying the package this file is a part of.
# You may not port this file to another platform without Apple's written consent.
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
class WebClipKnobSet < KnobSet
#-------------------------------------------------------------------------

  before_save :before_save_web_clip

  @@payload_type          = 'com.apple.webClip.managed'
  @@payload_subidentifier = 'webclip'
  @@is_unique             = false
  @@payload_name          = 'Web Clips'

  #-------------------------------------------------------------------------

  def attributes
    attr_dict = super
    attr_dict['Icon'] = BinaryData.new(attr_dict['Icon']) if attr_dict['Icon']
    return attr_dict
  end # attributes

  #-------------------------------------------------------------------------

  def before_save_web_clip
    df = self.data_file
    self.Icon = df.read_as_base64 if df
    return true
  end # before_save_web_clip

  #-------------------------------------------------------------------------

  def localized_payload_display_name(short = false)
    name = I18n.t('web_clip_display_name')
    name = sprintf(I18n.t('profile_long_display_format'), name, self.Label) unless short
    return name
  end # localized_payload_display_name

  #-------------------------------------------------------------------------

  def modify_attributes(attr_hash, extended = false)
    df = self.data_file
    attr_hash['data_files'] = [df.id] if df
    return attr_hash
  end # modify_attributes

#-------------------------------------------------------------------------
end # class WebClipKnobSet
#-------------------------------------------------------------------------
