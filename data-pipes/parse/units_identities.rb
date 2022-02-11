#!/usr/bin/sh ruby

module UnitsIdentities

  # TODO yml source
  IDENTITY_WORDS = %w{ CID EID EDT ORDER ACCOUNT Med Technician ID NAME Room Loc }
  IDENTITY_PHRASES = ["Test ind", "Referred by", "Confirmed by", "Vent. rate", "PR interval", "QRS duration", "QT/QTc", "P-R-T axes"]

  IDENTITIES = (
    IDENTITY_WORDS.sort   {|a,b| a.length <=> b.length }.reverse +
    IDENTITY_PHRASES.sort {|a,b| a.length <=> b.length }.reverse
  ).freeze

  UNIT_RATIOS = %w{ mm/s mm/mV } # '|' chars will break regexes
  UNIT_QUANTITIES = %w{ lb in YR BPM ms Hz }
  SEX = %w{ Male Female }
  RACE = [ "Caucasian", "Latino", "African", "Asian", "Native America", "Decline to self identify"]
  UNITS = (UNIT_RATIOS + UNIT_QUANTITIES + SEX + RACE).freeze

  DATE_INPUT_FORMAT  = /[2-9]{2}-[A-Z]{3}-[0-9]{4}/.freeze
  DATE_OUTPUT_FORMAT = "%F %H:%M:%S"

  def ident_r
    Regexp.new "("+IDENTITIES.join("|")+")"
  end

  def units_r
    Regexp.new( "("+UNITS.join("|")+")" ).freeze
  end
end
