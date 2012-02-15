CSV::Converters[:string] = lambda do |v|
  v.gsub(/^ +/, '').gsub(/ +$/, '').gsub(/^['\"]/, '').gsub(/['\"]$/, '') rescue nil
end

CSV::HeaderConverters[:symbol] = lambda do |h|
  h.downcase.tr(" ", "").delete("^a-z0-9_").to_sym rescue nil
end