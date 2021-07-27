class MountainDecorator < Draper::Decorator
  delegate_all

  # def image_url(version = :origin)
  #   return nil if !image? || !attachment.attached? || attachment.metadata.blank?
  #   if !image.attached?
  #     return '/images/img/portfolio/1.jpg'
  #   end

  #   command = case version
  #             when :thumb
  #               { resize: '640x480' }
  #             when :lg
  #               { resize: '1024x768' }
  #             else
  #               false
  #             end

  #   command ? attachment.variant(command).processed : attachment
  # end
end
