function filter_columns(number) {
  r = [];
  for (var i = 0; i < number; i++) {
    r.push({
      column_number: i,
      filter_type: 'text',
      filter_delay: 1000,
      data: {}
    });
  }
  return r;
}
