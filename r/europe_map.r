library(terra)
library(sf)
sf::sf_use_s2(FALSE)

#ne_bd = rast("data/HYP_50M_SR_W/HYP_50M_SR_W.tif")
ne_bd = rast("data/HYP_HR_SR_W/HYP_HR_SR_W.tif")

cb = st_read("data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp")
ext = raster::extent(c(-12, 30, 35, 60))
cb = st_crop(cb, ext)
ne_bd = crop(ne_bd, ext)

neretva = st_read("neretva_rn/output/neretva_sm.gpkg")
st_crs(neretva) = 3035

ne_bd = project(ne_bd,"epsg:3035")
RGB(ne_bd) = 1:3
cb = st_transform(cb, 3035)


box = as.vector(ext(neretva)) + c(-1, 1, -1, 1)*10000
jpeg(file="docs/img/europe_map.jpg", width=2000, height=1800, bg="transparent")
terra::plot(ne_bd, maxcell = ncell(ne_bd))
plot(st_geometry(cb), add=TRUE, col="#00000000", border = "#333333aa", lwd=0.5)
rect(box[1], box[3], box[2], box[4], lwd=2)
text(box[2], box[4], "Neretva", pos=4, offset = 0.2, cex=3)
plot(st_geometry(neretva), add=TRUE, col="blue")
dev.off()
