function resetImages()
global image left right
left = image .* uint8((image | right));
end