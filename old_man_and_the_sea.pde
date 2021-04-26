int[] sunset_colors = {#E7CA9E, #FFA25E, #A7C3D7, #4D85BC, #3C4C59};
color dark_sky = #5D5973;
PImage img;
boolean loop = true;

void settings(){
  img = loadImage("img.png");
  size(img.width,img.height);
}

void draw(){
  while(loop){
    pixel_sky(sunset_colors, 200, 300);
    noise_sky(3);
    darken_sky(dark_sky, 0.4);
    draw_waves(0.02, 2, 40, height/2, height, #4D85BC, #8AD6F0);
    image(img,0,0);
    saveFrame("#####.png");
    loop=false;
  }
}

void pixel_sky(int[] ss_c, int min_l, int max_l){
  loadPixels();
  for (int i = 0; i < width; i++){
    int j_pointer = 0;
    int c1_idx = 0;
    int c2_idx = 1;
    while (j_pointer < height){
      color c1 = ss_c[c1_idx];
      color c2 = ss_c[c2_idx];
      int l = int(random(min_l, max_l));
      for(int j_tmp = 0; (j_tmp<l)&(j_tmp+j_pointer<height); j_tmp++){
        pixels[i+width*(j_tmp+j_pointer)] = lerpColor(c1, c2, float(j_tmp)/float(l));
      }
      j_pointer = j_pointer + l;
      if (c1_idx < ss_c.length -1){
        c1_idx = (c1_idx+1);
      }
      if (c1_idx < ss_c.length -1){
        c2_idx = (c2_idx+1);
      }
    }
  }
  updatePixels();
}

void noise_sky(int max_shift){
  loadPixels();
  for(int j = 0; j < height; j++){
    int offset = int(max_shift*(noise(j)));
    for (int i = 0; i < width; i++){
      pixels[((i+offset)% width) + width*j] = pixels[i+j*width];
    }
  }
  updatePixels();
}

void darken_sky(color ds_c, float max_fade){
  loadPixels();
  for (int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      pixels[i+j*width] = lerpColor(pixels[i+j*width], ds_c, (float(i)/float(width))*max_fade);
    }
  }
  updatePixels();
}

void draw_waves(float detail, int space, float wave_height, int y_min, int y_max, color c1, color c2){
  for(int y = y_min; y < y_max; y+= space){
    for(int x = 0; x < width; x++){
      float h = wave_height*noise(y*detail, x*detail);
      stroke(lerpColor(c1, c2, noise(y,x)), 150);
      point(x, y+h);
    }
  }
}
