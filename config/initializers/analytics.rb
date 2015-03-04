if ENV['SEGMENT_KEY']
Analytics = Segment::Analytics.new({
    write_key: ENV['SEGMENT_KEY'],
    on_error: Proc.new { |status, msg| print msg }
})
else
  logger.warn "Segment Analytics disabled"
end
