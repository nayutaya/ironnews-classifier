#! ruby -Ku -Ilib

require "config"

printf("Number of Documents : %i\n", Document.count)
printf("Number of Features  : %i\n", Feature.count)

Document.all.destroy!
Feature.all.destroy!
