#!/usr/bin/env ruby

require 'RMagick'

def normalize(string)
	return string.sub(" / ", " - ").strip
end

# TODO command line options
names = File.new("lists/nethack.txt").readlines
dir = "tilesets/chozo32"
format = ".png"

imageListVertical = Magick::ImageList.new
for i in 0..29
	imageListHorizontal = Magick::ImageList.new
	for j in 0..39
		name = names[i*40+j]
		if name != nil then
			filename = dir+"/"+normalize(name)+format
			raise "Image #{filename} doesn't exist! " if not FileTest.exists?("#{filename}")
			imageListHorizontal.read filename
		else
			imageListHorizontal << Magick::Image.new(32, 32) { self.background_color = 'black' }
		end
	end
	imageListVertical << imageListHorizontal.append(false) if imageListHorizontal.length > 0
end

image = imageListVertical.append(true)
image.write "chozo32.png"
