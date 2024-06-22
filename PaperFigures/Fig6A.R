#Figure 6A

library(ggplot2)
library(magick)

urls <- c(
  #layer 1
  "http://www.dataconsulting.co.uk/wp-content/uploads/2017/08/Rlogo-300x263.png",
  "https://metinsaylan.com/_/m/2018/09/python-logo-large-380x380.png",
  "https://tech.bodyfitstation.com/wp-content/uploads/2016/11/git-logo.png",
  
  #layer 2
  "http://pngimg.com/uploads/github/github_PNG20.png",
  "https://www.unixtutorial.org/images/software/docker-containers-unixtutorial.png",
  "https://seeklogo.com/images/G/github-actions-logo-031704BDC6-seeklogo.com.png",
  "https://s28309.pcdn.co/wp-content/themes/321-web-marketing/assets/images/ec2-logo-256.png",
  
  #layer 3
  "https://stevenmortimer.com/blog/tips-for-making-professional-shiny-apps-with-r/shiny-hex.png",
  "https://raw.githubusercontent.com/github/explore/80f119e965a9a3df7b74c3f7b63a502e3d0ded36/topics/quarto/quarto.png"
)

#loop thru urls & save as raster
allimg <- lapply(urls,function(x){
  magick::image_read(x) |>
    magick::image_scale("100") |>
    as.raster()
})

#confirm intended num images saved
if(length(urls)==length(allimg)){
  print("Success")
  rm(urls)
}else{
  stop("NOT all images from `urls` saved.")
}

#params
x_min <- 0
x_max <- 10
y_bound <- seq(0,15,4)

stack_fig <- ggplot()+
  #layers
  geom_rect(
    aes(
      xmin=x_min,
      xmax=x_max,
      ymin=y_bound[1],
      ymax=y_bound[2]-1
    ),fill="red",alpha=0.4)+
  
  geom_rect(
    aes(
      xmin=x_min,
      xmax=x_max,
      ymin=y_bound[2],
      ymax=y_bound[3]-1
    ),fill="yellow",alpha=0.4)+
  
  geom_rect(
    aes(
      xmin=x_min,
      xmax=x_max,
      ymin=y_bound[3],
      ymax=y_bound[4]-1
    ),fill="green",alpha=0.4)+
  
  #'core (R, Python, git)
  #'y center: 1.5
  #'x centers: 2.5,5,7.5
  annotation_raster(allimg[[1]],xmin=1.8,xmax=3,ymin=0.8,ymax=2.05)+
  annotation_raster(allimg[[2]],xmin=4.4,xmax=5.6,ymin=0.4,ymax=2.3)+
  annotation_raster(allimg[[3]],xmin=7,xmax=8.5,ymin=0.25,ymax=2.6)+
  
  #'hosted (GitHub, Docker, GH Actions, EC2)
  #'y center: 5.5
  #'x centers: 1.25,3.75,6.25,8.75
  annotation_raster(allimg[[4]],xmin=0.75,xmax=2,ymin=4.5,ymax=6.5)+
  annotation_raster(allimg[[5]],xmin=3,xmax=4.6,ymin=4.5,ymax=6.5)+
  annotation_raster(allimg[[6]],xmin=5.7,xmax=7,ymin=4.5,ymax=6.5)+
  annotation_raster(allimg[[7]],xmin=7.6,xmax=9.35,ymin=4.3,ymax=6.6)+
  
  #'outputs (ODCdqa, ODCdqaFunctions, ODCdqaImage, Vignettes)
  annotation_raster(allimg[[8]],xmin=3,xmax=4.3,ymin=8.5,ymax=10.5)+
  annotation_raster(allimg[[9]],xmin=5.8,xmax=7.3,ymin=8.5,ymax=10.5)+
  
  #add text
  labs(title="ODCdqa Tech Stack")+
  annotate("text",x=0,y=(y_bound[2]-1.25),label="Core",
           color="black",size=5,fontface="bold",hjust=0,vjust=0)+
  annotate("text",x=0,y=(y_bound[3]-1.25),label="Host",
           color="black",size=5,fontface="bold",hjust=0,vjust=0)+
  annotate("text",x=0,y=(y_bound[4]-1.25),label="User Interface + Vignettes",
           color="black",size=5,fontface="bold",hjust=0,vjust=0)+
  
  #rm plot defaults
  theme(
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    axis.text=element_blank(),
    axis.title=element_blank(),
    axis.ticks.x=element_blank(),
    axis.ticks.y=element_blank(),
    panel.background=element_rect(fill="white"),
    plot.title=element_text(hjust=0.5,face="bold",size=20)
  )

#show figure
stack_fig

rm(x_min,x_max,y_bound)
gc()