#!/usr/bin/env ruby

require 'rubygems'
require "bundler/setup"

require 'RMagick'

@synonyms = Hash[
 "baby tatzelworm" => "baby gray dragon",
 "baby amphitere" => "baby silver dragon",
 "baby draken" => "baby red dragon",
 "baby lindworm" => "baby white dragon",
 "baby sarkany" => "baby orange dragon",
 "baby sirrush" => "baby black dragon",
 "baby leviathan" => "baby blue dragon",
 "baby wyvern" => "baby green dragon",
 "baby guivre" => "baby yellow dragon",
 "tatzelworm" => "gray dragon",
 "amphitere" => "silver dragon",
 "draken" => "red dragon",
 "lindworm" => "white dragon",
 "sarkany" => "orange dragon",
 "sirrush" => "black dragon",
 "leviathan" => "blue dragon",
 "wyvern" => "green dragon",
 "guivre" => "yellow dragon",
 "chromatic dragon" => "Chromatic Dragon",
 "tatzelworm scale mail / magic dragon scale mail" => "gray dragon scale mail",
 "amphitere scale mail / reflecting dragon scale mail" => "silver dragon scale mail",
 "draken scale mail / fire dragon scale mail" => "red dragon scale mail",
 "lindworm scale mail / ice dragon scale mail" => "white dragon scale mail",
 "sarkany scale mail / sleep dragon scale mail" => "orange dragon scale mail",
 "sirrush scale mail / disintegration dragon scale mail" => "black dragon scale mail",
 "leviathan scale mail / electric dragon scale mail" => "blue dragon scale mail",
 "wyvern scale mail / poison dragon scale mail" => "green dragon scale mail",
 "guivre scale mail / acid dragon scale mail" => "yellow dragon scale mail",
 "tatzelworm scales / magic dragon scales" => "gray dragon scales",
 "amphitere scales / reflecting dragon scales" => "silver dragon scales",
 "draken scales / fire dragon scales" => "red dragon scales",
 "lindworm scales / ice dragon scales" => "white dragon scales",
 "sarkany scales / sleep dragon scales" => "orange dragon scales",
 "sirrush scales / disintegration dragon scales" => "black dragon scales",
 "leviathan scales / electric dragon scales" => "blue dragon scales",
 "wyvern scales / poison dragon scales" => "green dragon scales",
 "guivre scales / acid dragon scales" => "yellow dragon scales",
 "viscous potion / levitation" => "cyan potion - levitation",
 "indigo potion / invisibility" => "brilliant blue potion - invisibility",
 "amber potion / healing" => "purple-red potion - healing",
 "AQUE BRAGH / flood" => "DUAM XNAHT - amnesia",

 "glowing dragon scale mail / stone dragon scale mail" => "gold dragon scale mail - stone dragon scale mail",
 "glowing dragon scales / stone dragon scales" => "gold dragon scales - stone dragon scales",
 "baby glowing dragon" => "baby gold dragon",
 "glowing dragon" => "gold dragon",
]

def normalize(string)
	return @synonyms[string.strip] if @synonyms.has_key? string.strip
	return string.sub(" / ", " - ").strip
end

# TODO command line options
names = File.new("lists/unnethack.txt").readlines
dir = "tilesets/unchozo32b"
format = ".png"

imageListVertical = Magick::ImageList.new
for i in 0..(names.size/40)
	imageListHorizontal = Magick::ImageList.new
	for j in 0..39
		name = names[i*40+j]
		if name != nil then
			filename = dir+"/"+normalize(name)+format
			if not FileTest.exists?("#{filename}") then
				puts "Image #{filename} doesn't exist! "
				imageListHorizontal << Magick::Image.new(32, 32) { self.background_color = 'yellow' }
			else
				imageListHorizontal.read filename
			end
		else
			imageListHorizontal << Magick::Image.new(32, 32) { self.background_color = 'black' }
		end
	end
	imageListVertical << imageListHorizontal.append(false) if imageListHorizontal.length > 0
end

image = imageListVertical.append(true)
image.write "unchozo32b.png"
