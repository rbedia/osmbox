@font_face: "DejaVu Sans Book";

@unknown: #ff0000;
@dist:    #7a7a85;
@v69:     #fc8d62;
@v115:    #8da0cb;
@v230:    #e78ac3;
@v345:    #a6d854;
@v500:    #ffd92f;
@v765:    #66c2a5;
@hvdc:    #4e01b5;

@line_case: #333333;
@tunnel_case: #7c4544;
@busbar_case: #aba668;
@power_pole: black;
@station_outline: #593815;
@text_halo: rgba(345,345,345,0.9);


#power_line::case[tunnel=1] {
    line-color: @tunnel_case;
    [zoom > 7] {
        line-width: 3;
    }
    [zoom > 11] {
        line-width: 8;
    }
    [zoom > 15] {
        line-width: 15;
    }
      line-join: round;
    line-cap: round;
}

#power_line::case[line="busbar"][zoom > 14] {
    line-color: @busbar_case;
    line-width: 5;
}

#power_line::case[frequency != "0"] {
    // AC power lines
    line-join: round;
    line-cap: round;
    line-color: @line_case;

    [voltage = null], [voltage < 69] {
        [zoom >= 10] {
            line-width: 3;
        }
    }

    [voltage >= 69][voltage < 115] {
        [zoom >= 10] {
            line-width: 4;
        }
    }
    [voltage >= 115][voltage < 230] {
        [zoom >= 9] {
            line-width: 4;
        }
    }

    [voltage >= 230][voltage < 345] {
        [zoom >= 8] {
            line-width: 5;
        }
    }

    [voltage >= 345][voltage < 500] {
        [zoom >= 4] {
            line-width: 4;
        }
        [zoom >= 9][line=""] {
            line-width: 5;
        }
    }

    [voltage >= 500][voltage < 765] {
        [zoom >= 4] {
            line-width: 5;
        }
        [zoom >= 9][line=""] {
            line-width: 6;
        }
    }

    [voltage >= 765] {
        line-width: 3;
        [zoom >= 4][line=""] {
            line-width: 5;
        }
        [zoom >= 9][line=""] {
            line-width: 6;
        }
    }
}

#power_line::fill [frequency != "0"] {
    // AC power lines
    line-join: round;
    line-cap: round;

    [location="underground"][tunnel != 1],
    [location="underwater"][tunnel != 1] {
        line-dasharray: 10, 5;
    }

    [voltage = null] {
        [zoom >= 10] {
            line-color: @unknown;
            line-width: 1;
        }
    }

    [voltage < 69] {
        [zoom >= 10] {
            line-color: @dist;
            line-width: 1;
        }
    }

    [voltage >= 69][voltage < 115] {
        [zoom >= 10] {
            line-width: 2;
            line-color: @v69;
        }
    }
    [voltage >= 115][voltage < 230] {
        [zoom >= 9] {
            line-width: 2;
            line-color: @v115;
        }
    }

    [voltage >= 230][voltage < 345] {
        [zoom >= 8] {
            line-width: 3;
            line-color: @v230;
        }
    }

    [voltage >= 345][voltage < 500] {
        [zoom >= 4] {
            line-color: @v345;
            line-width: 2;
        }
        [zoom >= 9][line=""] {
            line-color: @v345;
            line-width: 3;
        }
    }

    [voltage >= 500][voltage < 765] {
        [zoom >= 4] {
            line-color: @v500;
            line-width: 3;
        }
        [zoom >= 9][line=""] {
            line-color: @v500;
            line-width: 4;
        }
    }

    [voltage >= 765] {
        line-color: @v765;
        line-width: 1;
        [zoom >= 4][line=""] {
            line-width: 3;
        }
        [zoom >= 9][line=""] {
            line-width: 4;
        }
    }
}

#power_line::fill [frequency = "0"] {
    // HVDC interconnectors
    line-color: @hvdc;
    line-width: 1;
    line-dasharray: 10, 5;
    [zoom >= 3] {
        line-color: @hvdc;
        line-width: 2;
    }
    [zoom >= 8] {
        line-color: @hvdc;
        line-width: 4;
    }
}

#power_tower[zoom>14][type="tower"] {
    marker-file: url('symbols/power_tower.svg');
    marker-width: 8;
}

#power_tower[zoom>14][type="pole"] {
    marker-type: ellipse;
    marker-fill: @power_pole;
    marker-line-width: 0;
    marker-width: 4;
}

/* Render substations as circles at lower zooms */
#substation_point[zoom = 8][substation != "transition"][voltage >= 500],
    #substation_point[zoom >= 9][zoom < 11][substation != "transition"][voltage >= 345],
    #substation_point[zoom >= 11][zoom < 13][substation != "transition"][voltage >= 115] {
    marker-type: ellipse;

    /* Mapnik is extremely choosy about this rule ordering, beware. */
    [voltage >= 765] {
        marker-line-width: 2;
        marker-line-color: black;
        marker-fill: @v765;
        marker-width: 15;
        [zoom = 8] {
            marker-width: 8;
        }
    }
    [voltage >= 500][voltage < 765] {
        marker-line-width: 2;
        marker-line-color: black;
        marker-fill: @v500;
        marker-width: 12;
        [zoom = 8] {
            marker-width: 8;
        }
    }
    [voltage >= 345][voltage < 500] {
        marker-line-width: 2;
        marker-line-color: black;
        marker-fill: @v345;
        marker-width: 10;
    }
    [voltage >= 230][voltage < 345] {
        marker-line-width: 2;
        marker-line-color: black;
        marker-fill: @v230;
        marker-width: 8;
    }
    [voltage >= 115][voltage < 230] {
        marker-line-width: 1;
        marker-line-color: black;
        marker-fill: @v115;
        marker-width: 5;
    }
}

#substation::outline[zoom >= 13] {
    line-color: @station_outline;
    line-width:3;
}

/* Fill substations with their corresponding colour at medium zooms */
#substation::body[zoom >= 13][zoom < 15] {
    [voltage >= 115][voltage < 230] {
        polygon-fill: @v115;
    }
    [voltage >= 230][voltage < 345] {
        polygon-fill: @v230;
    }
    [voltage >= 345][voltage < 500] {
        polygon-fill: @v345;
    }
    [voltage >= 500][voltage < 765] {
        polygon-fill: @v500;
    }
    [voltage >= 765] {
        polygon-fill: @v765;
    }
}

/* Render substations mapped as points */
#substation["mapnik::geometry_type" = 1][zoom >= 13] {
    marker-width:5;
    marker-type: ellipse;
    marker-line-width: 1;
    marker-line-color: black;
    [voltage <= 115], [voltage = null] {
		marker-fill: @unknown;
    }
    [voltage >= 115][voltage < 230] {
        marker-fill: @v115;
    }
    [voltage >= 230][voltage < 345] {
        marker-fill: @v230;
    }
    [voltage >= 345][voltage < 500] {
        marker-fill: @v345;
    }
    [voltage >= 500][voltage < 765] {
        marker-fill: @v500;
    }
    [voltage >= 765] {
        marker-fill: @v765;
    }
}


#power_plant_point[zoom < 13][zoom > 5][output > 100],
    #power_plant_point[zoom < 13][zoom > 9][output < 100][output > 10],
    #power_plant_point[zoom < 13][zoom > 11][output < 10]{
    marker-width: 20;
    marker-file: url('symbols/freepik/power_plant.svg');
    [source = "coal"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_coal.svg');
    }
    [source = "geothermal"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_geothermal.svg');
    }
    [source = "hydro"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_hydro.svg');
    }
    [source = "nuclear"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_nuclear.svg');
    }
    [source = "oil"], [source="gas"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_oilgas.svg');
    }
    [source = "solar"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_solar.svg');
    }
    [source = "wind"] {
        marker-width: 20;
        marker-file: url('symbols/freepik/power_plant_wind.svg');
    }

    /* Render these on top of substations, as they're
     * always next door and the power plant is more important. */
    marker-allow-overlap: true;
}

#power_plant[zoom>=13] {
    line-color: @station_outline;
    line-width:1;
}

#power_generator[source = "wind"][zoom > 10] {
    marker-file: url('symbols/power_wind.svg');
    marker-width: 10;
}

#power_transformer[zoom > 14] {
    marker-file: url('symbols/power_transformer.svg');
    marker-width: 10;
}

#substation::label[zoom >= 13],
    #substation::label[zoom >= 11][zoom < 13][voltage >= 345]{
    text-size: 12;
    text-dy: 10;
    text-halo-radius: 2;
    [zoom >= 14] {
        text-halo-radius: 4;
    }
    text-halo-fill: @text_halo;
    text-face-name: @font_face;
    text-fill: black;
    text-wrap-width: 50;

    [name != ""] {
        text-name: "[name]";
    }
    [voltage > 0][zoom >= 13] {
        text-name: "'Substation ' + [voltage] + 'kV'";
        [name != ""] {
            text-name: "[name] + ' ' + [voltage] + 'kV'";
        }
    }
}

/* Label power lines
 * (but not line=busbar or line=bay)
 */
#power_line::label[line = ''] {
    text-size: 9;
    text-placement: line;
    text-halo-radius: 2;
    text-dy: 5;
    [tunnel=1] {
        text-dy:10;
    }
    text-halo-fill: @text_halo;
    text-face-name: @font_face;
    text-fill: black;
    text-min-path-length: 100;
    text-spacing: 700;
    [zoom>13] {
        text-name: "[name]";
        [voltage > 0] {
            text-name: "[name] + ' ' + [voltage] + 'kV'";
        }
        [frequency = "0"] {
            text-name: "[name] + ' (HVDC)'"
        }
    }
}

/* Label power line references as a shield.
 * This currently only supports references shorter than 5 characters.
 */
#power_line::ref[ref != ''][ref_len < 5][zoom > 11] {
    shield-file: url('symbols/power_line_ref.svg');
    shield-name: "[ref]";
    shield-face-name: @font_face;
    shield-fill: black;
    shield-size: 9;
    shield-placement: line;
    shield-spacing: 400;
}

#power_tower::ref[ref != ''][zoom > 15] {
    text-size: 9;
    text-name: "[ref]";
    text-fill: black;
    text-face-name: @font_face;
    text-halo-fill: @text_halo;
    text-halo-radius: 2;
}

#power_plant::label[zoom >= 9][zoom < 12][output > 100],
  #power_plant::label[zoom >= 12] {
    text-size: 12;
    text-dy: 10;
    text-halo-radius: 2;
    [zoom >= 14] {
        text-halo-radius: 4;
    }
    text-halo-fill: @text_halo;
    text-face-name: @font_face;
    text-fill: black;
    text-wrap-width: 50;
    text-name: "[label]";
}

