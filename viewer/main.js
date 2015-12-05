function float_format(x, prec) {
    return Math.round(x*Math.pow(10,prec))/Math.pow(10,prec);
}

$(document).ready(function() {
    var datasets = [ 
    ];
    $.ajax({
        url: 'data/datasets.json',
        async: false,
        success: function (data) {
          var obj = JSON.parse(data);
          datasets = obj;
        }
    });


    var methods = [ 
    ];
    $.ajax({
        url: 'data/methods.json',
        async: false,
        success: function (data) {
          var obj = JSON.parse(data);
          methods = obj;
        }
    });


    var images = [ 
    ];

    // Fill in drop-down lists
    Object.keys(datasets).forEach(function(t) { 
        $('#selDataset').append('<option>'+t+'</option>');
    });
    var all_methods = Object.keys(methods);
    all_methods.push('ground_truth');
    all_methods.forEach(function(t) { 
        $('#selLeftMethod').append('<option>'+t+'</option>');
        $('#selRightMethod').append('<option>'+t+'</option>');
    });

    var dataset      = $("#selDataset").val();
    update_image_list();
    var left_method  = $('#selLeftMethod').val();
    var right_method = $('#selRightMethod').val();

    function update_score_table() {
        var str = 
            "<tr>" +
                "<th>name</th> " +
                "<th>n</th>" +
                "<th>PSNR</th>" +
                "<th>R</th>" +
                "<th>G</th>" +
                "<th>B</th>" +
                "<th>time</th>" +
            "</tr>";

        var scores = [];
        for(m in methods) {
            var obj = methods[m][dataset];
            obj['name'] = m;
            scores.push(obj);
        }
        scores.sort(function(a, b) {
            if ( a.psnr < b.psnr )
                return 1;
            if ( a.psnr > b.psnr )
                return -1;
            return 0;
        });
        console.log(scores);

        for(s in scores) {
            str +=
            "<tr>" +
                "<td>"+ scores[s].name + "</td> " +
                "<td>"+ scores[s].n + "</td> " +
                "<td>"+ float_format(scores[s]["psnr"],1)   + " dB </td> " +
                "<td>"+ float_format(scores[s]["psnr_r"],1) + " dB </td> " +
                "<td>"+ float_format(scores[s]["psnr_g"],1) + " dB </td> " +
                "<td>"+ float_format(scores[s]["psnr_b"],1) + " dB </td> " +
                "<td>"+ float_format(scores[s]["time"],0) + "ms </td> " +
            "</tr>";
        }
        $("#score_table").html(str);
    };
    update_score_table();

    var path_left   = '';
    var path_right  = '';

    var im_left  = new Image();
    var im_right = new Image();

    var ready_l  = false;
    var ready_r  = false;
    var width_l  = 0;
    var width_r  = 0;
    var height_l = 0;
    var height_r = 0;

    im_left.onload = function() {
        width_l  = im_left.width;
        height_l = im_left.height;
        ready_l  = true;
        make_viewer();
    };

    im_right.onload = function() {
        width_r  = im_right.width;
        height_r = im_right.height;
        ready_r  = true;
        make_viewer();
    };

    function make_viewer() {
        $('#split_viewer').html('')
        if (!ready_l || !ready_r) {
            return;
        }
        if(width_l != width_r || height_l != height_r) {
            console.log("viewer sizes do not match !");
        }
        twoface = TwoFace('split_viewer', width_l, height_l);
        twoface.add(path_left);
        twoface.add(path_right);
    };

    function update_left() {
        if(!imname){
            return;
        }
        ready_l = false;
        path_left   = 'output/'+left_method+'/'+dataset+'/'+imname;
        im_left.src = path_left;

        if(left_method == "ground_truth") {
            $("#psnr_left").html('--');
            $("#psnr_red_left").html('--');
            $("#psnr_green_left").html('--');
            $("#psnr_blue_left").html('--');
            $("#time_left").html('--');
        } else {
            json_left   = 'output/'+left_method+'/'+dataset+'/'+imname.split('.')[0]+'.json';
            $.ajax({
                url: json_left,
                success: function (data) {
                  var obj = JSON.parse(data);
                  $("#psnr_left").html(float_format(obj.psnr,1)+" dB");
                  $("#psnr_red_left").html(float_format(obj.psnr_r,1)+" dB");
                  $("#psnr_green_left").html(float_format(obj.psnr_g,1)+" dB");
                  $("#psnr_blue_left").html(float_format(obj.psnr_b,1)+" dB");
                  $("#time_left").html(float_format(obj.time,0)+" ms");
                }
            });
        }

    };

    function update_right() {
        if(!imname){
            return;
        }
        ready_r = false;
        path_right  = 'output/'+right_method+'/'+dataset+'/'+imname;
        im_right.src = path_right;

        if(right_method == "ground_truth") {
            $("#psnr_right").html('--');
            $("#psnr_red_right").html('--');
            $("#psnr_green_right").html('--');
            $("#psnr_blue_right").html('--');
            $("#time_right").html('--');
        } else {
            json_right   = 'output/'+right_method+'/'+dataset+'/'+imname.split('.')[0]+'.json';
            $.ajax({
                url: json_right,
                success: function (data) {
                  var obj = JSON.parse(data);
                  $("#psnr_right").html(float_format(obj.psnr,1)+" dB");
                  $("#psnr_red_right").html(float_format(obj.psnr_r,1)+" dB");
                  $("#psnr_green_right").html(float_format(obj.psnr_g,1)+" dB");
                  $("#psnr_blue_right").html(float_format(obj.psnr_b,1)+" dB");
                  $("#time_right").html(float_format(obj.time,0)+" ms");
                }
            });
        }

    };

    function update_image_list(){
        images = []
        $('#selImage')
            .find('option')
            .remove();
        $.ajax({
            url: 'data/datasets.json',
            async: false,
            success: function (data) {
                var obj = JSON.parse(data);
                for(k in obj) {
                    if( k = dataset){
                        images = obj[k];
                        break;
                    }
                  }
                }
        });
        images.forEach(function(t) { 
            $('#selImage').append('<option>'+t+'</option>');
        });
        imname = $("#selImage").val();
    };


    $('#selDataset').change(function() {
        dataset = $('#selDataset').val();
        $('#datasetTitle').text(dataset);
        ready_r = false;
        ready_l = false;
        update_score_table();
        update_image_list();
        update_left();
        update_right();
    });

    $('#selImage').change(function() {
        imname = $('#selImage').val();
        ready_r = false;
        ready_l = false;
        update_left();
        update_right();
    });

    $('#selLeftMethod').change(function() {
        left_method = $('#selLeftMethod').val();
        $('#leftTitle').text(left_method);
        update_left();
    });

    $('#selRightMethod').change(function() {
        right_method = $('#selRightMethod').val();
        $('#rightTitle').text(right_method);
        update_right();
    });

    $("#selRightMethod").change();
    $("#selLeftMethod").change();

});
