require 'sprite_factory'

namespace :assets do
  desc 'recreate sprite images and css'
  task resprite: :environment do 
    SpriteFactory.run!('app/assets/images/sprites', output_style: 'app/assets/stylesheets/desktop/sprites.scss', cssurl: "image-url('$IMAGE')", layout: :packed)
  end
end
