counties <- readOGR(dsn="data/vg2500_geo84/", layer="vg2500_krs")

counties@data$id = rownames(counties@data)

gpclibPermit()
counties.points = fortify(counties, region="id")

counties.df = join(counties.points, counties@data, by="id")

BIP <- subset(db_select, db_select$variable == 'BIP')
colnames(BIP) <- c("id", "RS", "variable", "year", "BIP")

df$density <- (df$male + df$female) / df$area  # Calculate population density per sqKm

BIP <- join(BIP, df, by = 'RS')
BIP$BIP <- BIP$BIP / 1000000

counties.df = join(counties.df, BIP, by = 'RS')
counties.df = join(counties.df, df, by = 'RS')



p <- ggplot(counties.df, aes(x=long, y=lat, group = group)) + 
        geom_polygon(aes(fill = BIP)) +
        coord_map("gilbert") +
        geom_path(color="white") +
        scale_fill_continuous("GDP in Mil.",limits=c(880, 73000), breaks = c(880, 4000, 73000), low="yellow", high="red", trans = "log", guide = guide_colorbar(nbin=400, draw.ulim = TRUE, draw.llim = TRUE)) +
        theme(plot.margin = unit(c(2,2,2,2), "mm")) 
ggsave(p, file='graphs/counties.pdf', width = 8, height = 8)


q <- qplot(density, BIP, data=BIP, geom=c("point", "smooth"), 
        method="lm", formula=y~x, color=type, 
        xlab="LN GDP in Mil.", ylab="LN Density of population") +
        geom_text(aes(density, BIP, label = county)) +
        scale_y_log10() +
        scale_x_log10() +
        theme(axis.title.y = element_text(vjust = 0.4, angle = 90, size = 9),
              axis.title.x = element_text(vjust = 0.4, size = 9),
              axis.text.x = element_text(size = 8),
              axis.text.y = element_text(size = 8),
              strip.text.x = element_text(size = 8),
              plot.margin = unit(c(2,2,2,2), "mm"))

ggsave(q, file='graphs/RegressionDensityGDP.pdf')