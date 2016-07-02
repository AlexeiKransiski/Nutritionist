
 $( document ).ready(function() {

	// Line chart options
	var options = {
	    //Boolean - Whether grid lines are shown across the chart
	    scaleShowGridLines : true,
	    //String - Colour of the grid lines
	    scaleGridLineColor : "rgba(0,0,0,.05)",
	    //Number - Width of the grid lines
	    scaleGridLineWidth : 1,
	    //Boolean - Whether to show horizontal lines (except X axis)
	    scaleShowHorizontalLines: true,
	    //Boolean - Whether to show vertical lines (except Y axis)
	    scaleShowVerticalLines: true,
	    //Boolean - Whether the line is curved between points
	    bezierCurve : true,
	    //Number - Tension of the bezier curve between points
	    bezierCurveTension : 0.4,
	    //Boolean - Whether to show a dot for each point
	    pointDot : true,
	    //Number - Radius of each point dot in pixels
	    pointDotRadius : 4,
	    //Number - Pixel width of point dot stroke
	    pointDotStrokeWidth : 1,
	    //Number - amount extra to add to the radius to cater for hit detection outside the drawn point
	    pointHitDetectionRadius : 20,
	    //Boolean - Whether to show a stroke for datasets
	    datasetStroke : true,
	    //Number - Pixel width of dataset stroke
	    datasetStrokeWidth : 2,
	    //Boolean - Whether to fill the dataset with a colour
	    datasetFill : true,
	    //String - A legend template
	    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].strokeColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
	};

	// Global settings
	Chart.defaults.global.responsive = true;
	Chart.defaults.global.scaleOverride = true;
	Chart.defaults.global.scaleSteps = 3;
	Chart.defaults.global.scaleStepWidth = 50;
	Chart.defaults.global.scaleStartValue = 0;
	Chart.defaults.global.scaleShowLabels = true;
	Chart.defaults.global.scaleLabel = "<%=value + 'mm'%>";
	Chart.defaults.global.scaleFontSize = 10;


	// Line chart for status by year in my status ------------------------------------------
	// Get context for progress tracker
	var sby = $("#statusByYear").get(0).getContext("2d");

	// Hardcoded datasets for status by year
	var status_by_year_datasets = {
		datasets: [
	        {
	            label: "2015",
	            fillColor: "rgba(78,145,217,0.4)",
	            strokeColor: "rgba(115,164,216,1)",
	            pointColor: "rgba(115,164,216,1)",
	            pointStrokeColor: "#fff",
	            pointHighlightFill: "rgba(115,164,216,1)",
	            pointHighlightStroke: "#fff",
	            data: [0, 40, 80, 100, 80, 150, 80, 150, 80, 70, 50, 20]
	        },
	        {
	            label: "2014",
	            fillColor: "rgba(166,207,251,0.4)",
	            strokeColor: "rgba(217,226,236,1)",
	            pointColor: "rgba(183,200,219,1)",
	            pointStrokeColor: "#fff",
	            pointHighlightFill: "rgba(183,200,219,1)",
	            pointHighlightStroke: "#fff",
	            data: [0, 90, 60, 90, 130, 90, 60, 90, 130, 140, 145, 150]
	        }
	    ]
	};

	// Datasets for status by year
	var status_by_year_data = {
	    labels: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "NOV", "DEC"],
		datasets: status_by_year_datasets.datasets
	};

	// Draw the chart
	var statusByYear = new Chart(sby).Line(status_by_year_data, options);

	// Line chart for progress tracker in my status ------------------------------------------
	// Get context for progress tracker
	var ctx = $("#progressTracker").get(0).getContext("2d");

	// Hardcoded datasets for progress tracker by various stats
	var progress_tracker_datasets = {
		datasets: [
	        {
	            label: "Neck",
	            fillColor: "rgba(25,255,100,0.4)",
	            strokeColor: "rgba(88,208,148,1)",
	            pointColor: "rgba(54,190,122,1)",
	            pointStrokeColor: "#fff",
	            pointHighlightFill: "rgba(54,190,122,1)",
	            pointHighlightStroke: "#fff",
	            data: [80, 150, 80, 150, 80, 150, 80, 150, 80, 150, 80, 150]
	        },
	        {
	            label: "Chest",
	            fillColor: "rgba(29,185,223,0.4)",
	            strokeColor: "rgba(83,165,185,1)",
	            pointColor: "rgba(72,138,155,1)",
	            pointStrokeColor: "#fff",
	            pointHighlightFill: "rgba(72,138,155,1)",
	            pointHighlightStroke: "#fff",
	            data: [130, 90, 60, 90, 130, 90, 60, 90, 130, 90, 60, 90]
	        },
	        {
	            label: "Upper Arm Left",
	            fillColor: "rgba(134,88,239,0.4)",
	            strokeColor: "rgba(198,176,249,1)",
	            pointColor: "rgba(164,128,245,1)",
	            pointStrokeColor: "#fff",
	            pointHighlightFill: "rgba(164,128,245,1)",
	            pointHighlightStroke: "#fff",
	            data: [50, 90, 140, 90, 50, 90, 140, 90, 50, 90, 140, 90]
	        }
	    ]
	};

	// Datasets for progress tracker by various stats
	var progress_tracker_data = {
	    labels: ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "NOV", "DEC"],
		datasets: [progress_tracker_datasets.datasets[0]]
	};

	// Draw the chart
	var progressTracker = new Chart(ctx).Line(progress_tracker_data, options);

	jQuery('.progress_tracker_stat').click(function() {

		progress_tracker_data.datasets = [];

		jQuery(this).parents('form').find('input:checked').each(function() {
			progress_tracker_datasets.datasets[jQuery(this).attr('value')];
			progress_tracker_data.datasets.push(progress_tracker_datasets.datasets[jQuery(this).attr('value')]);
		});

		if (progress_tracker_data.datasets.length) {
			// Draw the chart
			var progressTracker = new Chart(ctx).Line(progress_tracker_data, options);
		}

	});
});
