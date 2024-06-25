# Download BlackMarble Data

# Setup ------------------------------------------------------------------------
# Load bearer token
bearer <- file.path(ntl_dir, "blackmarble-bearer-token", "bearer_bm.csv") %>%
  read_csv() %>%
  pull("token")

# Load Lebanon boundaries
roi_sf <- read_sf(file.path(admin_bnd_dir, "lbn_adm_cdr_20200810", "lbn_admbnda_adm0_cdr_20200810.shp"))

# Download data ----------------------------------------------------------------
bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A3",
          date = seq.Date(from = ymd("2012-01-01"), to = Sys.Date(), by = "month"),
          bearer = bearer,
          quality_flag_rm = c(255,1),
          output_location_type = "file",
          file_dir = file.path(ntl_dir, "ntl-rasters", "blackmarble", "monthly"))

bm_raster(roi_sf = roi_sf,
          product_id = "VNP46A4",
          date =2012:2023,
          bearer = bearer,
          quality_flag_rm = c(255,1),
          output_location_type = "file",
          file_dir = file.path(ntl_dir, "ntl-rasters", "blackmarble", "annual"))
