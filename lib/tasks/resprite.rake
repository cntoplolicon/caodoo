require 'sprite_factory'

namespace :assets do
  desc 'recreate sprite images and css'
  task resprite: :environment do 
    SpriteFactory.run!('app/assets/images/sprites/desktop', output_style: 'app/assets/stylesheets/desktop/sprites.scss', output_image: 'app/assets/images/sprites-desktop.png', cssurl: "image-url('$IMAGE')", layout: :packed)
    SpriteFactory.run!('app/assets/images/sprites/mobile', output_style: 'app/assets/stylesheets/mobile/sprites.scss', output_image: 'app/assets/images/sprites-mobile.png', cssurl: "image-url('$IMAGE')", layout: :packed)
  end
end
