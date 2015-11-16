function float_format(x, prec) {
    return Math.round(x*Math.pow(10,prec))/Math.pow(10,prec);
}

$(document).ready(function() {
    var datasets = [ 
        "mcm",
    ];

    var methods = [ 
        "ground_truth",
        "bilinear",
        "ahd",
        "dlmmse",
        "ldi_nat",
        "flexisp",
        "our_cnn"
    ];

    var images = [ 
        'mcm_1.png',
        'mcm_2.png',
        'mcm_3.png',
        'mcm_4.png',
        'mcm_5.png',
        'mcm_6.png',
        'mcm_7.png',
        'mcm_8.png',
        'mcm_9.png',
        'mcm_10.png',
        'mcm_11.png',
        'mcm_12.png',
        'mcm_13.png',
        'mcm_14.png',
        'mcm_15.png',
        'mcm_16.png',
        'mcm_17.png',
        'mcm_18.png'
    ];

    // Fill in drop-down lists
    datasets.forEach(function(t) { 
        $('#selDataset').append('<option>'+t+'</option>');
    });
    images.forEach(function(t) { 
        $('#selImage').append('<option>'+t+'</option>');
    });
    methods.forEach(function(t) { 
        $('#selLeftMethod').append('<option>'+t+'</option>');
        $('#selRightMethod').append('<option>'+t+'</option>');
    });

    var dataset      = $("#selDataset").val();
    var imname      = $("#selImage").val();
    var left_method  = $('#selLeftMethod').val();
    var right_method = $('#selRightMethod').val();

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
        console.log('make_viewer')
        if (!ready_l || !ready_r) {
            console.log("one image is not ready");
            return;
        }
        if(width_l != width_r || height_l != height_r) {
            console.log("viewer sizes do not match !");
        }
        twoface = TwoFace('split_viewer', width_l, width_r);
        twoface.add(path_left);
        twoface.add(path_right);
    };

    function update_left() {
        ready_l = false;
        console.log('update left')
        path_left   = 'output/'+left_method+'/'+dataset+'/'+imname;
        im_left.src = path_left;

        if(left_method == "ground_truth") {
            $("#psnr_left").html('--');
            $("#time_left").html('--');
        } else {
            json_left   = 'output/'+left_method+'/'+dataset+'/'+imname.split('.')[0]+'.json';
            console.log("JSONG: "+json_left)
            $.ajax({
                url: json_left,
                success: function (data) {
                  var obj = JSON.parse(data);
                  $("#psnr_left").html(float_format(obj.psnr,1)+" dB");
                  $("#time_left").html(float_format(obj.time,0)+" ms");
                }
            });
        }

    };

    function update_right() {
        ready_r = false;
        console.log('update right')
        path_right  = 'output/'+right_method+'/'+dataset+'/'+imname;
        im_right.src = path_right;

        if(right_method == "ground_truth") {
            $("#psnr_right").html('--');
            $("#time_right").html('--');
        } else {
            json_right   = 'output/'+right_method+'/'+dataset+'/'+imname.split('.')[0]+'.json';
            console.log("JSONG: "+json_right)
            $.ajax({
                url: json_right,
                success: function (data) {
                  var obj = JSON.parse(data);
                  $("#psnr_right").html(float_format(obj.psnr,1)+" dB");
                  $("#time_right").html(float_format(obj.time,0)+" ms");
                }
            });
        }

    };


    $('#selDataset').change(function() {
        dataset = $('#selDataset').val();
        $('#datasetTitle').text(dataset);
        ready_r = false;
        ready_l = false;
        update_left();
        update_right();
    });

    $('#selImage').change(function() {
            console.log('change image')
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
