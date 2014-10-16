<?php
/**********************************************************
 * A function for serving the composite histogram as      *
 * space-separated integers.                              *
 * Use: histogram-controlled illumination project.        *
 * @author Mikko Tuohimaa 2011                            *
 *********************************************************/
$h_arr = elphel_histogram_get(0xfff, elphel_get_frame()-1);
$r = array_slice($h_arr, 0, 256);
$g1 = array_slice($h_arr, 256, 256);
$g2 = array_slice($h_arr, 512, 256);
$b = array_slice($h_arr, 768, 256);

for ($i = 0; $i < 256; ++$i) {
    $elem = ($r[$i] + $g1[$i] + $g2[$i] + $b[$i])/4;
    printf("%d ", $elem);
}
exit();
