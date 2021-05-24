#!/usr/bin/env ruby

require 'rubygems'
require "bundler/setup"

require 'rmagick'

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
  "baby glowing dragon" => "baby gold dragon",
  "glowing dragon" => "gold dragon",

  "baby tatzelworm (statue)" => "baby gray dragon (statue)",
  "baby amphitere (statue)" => "baby silver dragon (statue)",
  "baby draken (statue)" => "baby red dragon (statue)",
  "baby lindworm (statue)" => "baby white dragon (statue)",
  "baby sarkany (statue)" => "baby orange dragon (statue)",
  "baby sirrush (statue)" => "baby black dragon (statue)",
  "baby leviathan (statue)" => "baby blue dragon (statue)",
  "baby wyvern (statue)" => "baby green dragon (statue)",
  "baby guivre (statue)" => "baby yellow dragon (statue)",
  "tatzelworm (statue)" => "gray dragon (statue)",
  "amphitere (statue)" => "silver dragon (statue)",
  "draken (statue)" => "red dragon (statue)",
  "lindworm (statue)" => "white dragon (statue)",
  "sarkany (statue)" => "orange dragon (statue)",
  "sirrush (statue)" => "black dragon (statue)",
  "leviathan (statue)" => "blue dragon (statue)",
  "wyvern (statue)" => "green dragon (statue)",
  "guivre (statue)" => "yellow dragon (statue)",
  "chromatic dragon (statue)" => "Chromatic Dragon (statue)",
  "baby glowing dragon (statue)" => "baby gold dragon (statue)",
  "glowing dragon (statue)" => "gold dragon (statue)",

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

  "warped amulet / amulet of flying" => "warped amulet",

  "splash of ice / freezing ice" => "freezing ice - splash of ice",

  "AQUE BRAGH / flood" => "DUAM XNAHT - amnesia",
  "ASHPD SODALG" => "ASHPD",
  "STRC PRST SKRZ KRK" => "SODALG",
  "XOR OTA" => "ACHAT SHTAYIM SHALOSH",

  "glowing dragon scale mail / stone dragon scale mail" => "gold dragon scale mail - stone dragon scale mail",
  "glowing dragon scales / stone dragon scales" => "gold dragon scales - stone dragon scales",

  "Anaraxis the Black" => "Dark One",
  "Anaraxis the Black (statue)" => "Dark One (statue)",

  "swallow top left" => "swallow top-left",
  "swallow top center" => "swallow top",
  "swallow top right" => "swallow top-right",
  "swallow middle left" => "swallow middle-left",
  "swallow middle right" => "swallow middle-right",
  "swallow bottom left" => "swallow bottom-left",
  "swallow bottom center" => "swallow bottom",
  "swallow bottom right" => "swallow bottom-right",
]

def normalize(string)
  return @synonyms[string.strip] if @synonyms.has_key? string.strip
  return string.sub(" / ", " - ").strip
end

# TODO command line options
list = "lists/unnethack.txt"
names = File.new(list).readlines
dir = "tilesets/unchozo32b"
format = ".png"
output_name = [list.split(/(?:\.txt|\/)/).last, "-", dir.split("/").last, format].join

imageListVertical = Magick::ImageList.new
for i in 0..(names.size/40)
  imageListHorizontal = Magick::ImageList.new
  for j in 0..39
    name = names[i*40+j]
    if name != nil then
      filename = dir+"/"+normalize(name)+format
      if !FileTest.exists?("#{filename}") then
        if name.strip.end_with?(" (statue)")
          image = Magick::Image.read(filename.split(" (statue)").join).first
          imageListHorizontal << image.quantize(256, Magick::GRAYColorspace)
        else
          puts "Image #{filename} doesn't exist! "
          imageListHorizontal << Magick::Image.new(32, 32) { self.background_color = 'yellow' }
        end
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
image.write output_name
