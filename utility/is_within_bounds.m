function is_within = is_within_bounds(point, width, height)
    x = point(1);
    y = point(2);
    is_within = (x >= 0 && x <= width && y >= 0 && y <= height);
end