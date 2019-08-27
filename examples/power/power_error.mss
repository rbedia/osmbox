@unknown: #ff0000;

[zoom >= 4] {
	// power lines without voltage or frequency
	#power_line::fill[voltage = null], #power_line::fill[frequency = ""] {
		line-join: round;
		line-cap: round;
		line-width: 4;
		#power_line::fill[frequency = ""] {
			line-color: #ff9900;
		}
		#power_line::fill[voltage = null] {
			line-color: @unknown;
		}
	}
	// substations without voltage
	#substation_point[voltage = null] {
		marker-type: ellipse;
		marker-line-width: 1;
		marker-line-color: #000000;
		marker-fill: @unknown;
		marker-width: 5;
	}
	// ambiguous/old stations
	#oldstation_point {
		marker-type: ellipse;
		marker-line-width: 1;
		marker-line-color: #000000;
		marker-fill: #ff9900;
		marker-width: 5;
	}
}

