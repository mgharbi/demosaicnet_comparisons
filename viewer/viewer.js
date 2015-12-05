function TwoFace(id, width, height) {
    if (!(this instanceof TwoFace)) {
        return new TwoFace(id, width, height);
    }

    var canvas = document.createElement('canvas'),
        container = document.getElementById(id),
        divide = 0.5;

    this.ctx = canvas.getContext('2d');
    trackTransforms(this.ctx);
    this.images = [];

    // Event handlers
    canvas.addEventListener('mousemove', handler, false);
    canvas.addEventListener('mousedown', handler, false);
    canvas.addEventListener('mouseup', handler, false);
    canvas.addEventListener('mousewheel', handler, false);

    this.canvas = canvas;

    var self = this;

    // UI variables
    this.lastX = canvas.width/2;
    this.lastY = canvas.height/2;
    this.dragStart = false;
    this.dragged = false;

    function handler(ev) {
        if (ev.layerX || ev.layerX == 0) { // Firefox
            ev._x = ev.layerX;
            ev._y = ev.layerY;
        } else if (ev.offsetX || ev.offsetX == 0) { // Opera
            ev._x = ev.offsetX;
            ev._y = ev.offsetY;
        }

        var eventHandler = self[ev.type];
        if (typeof eventHandler == 'function') {
            eventHandler.call(self, ev);
        }
    }

    // Draw canvas into its container
    var maxSz = 500;
    // canvas.setAttribute('width', maxSz);
    // canvas.setAttribute('height', maxSz);
    canvas.setAttribute('width', width);
    canvas.setAttribute('height', height);
    container.appendChild(canvas);

    Object.defineProperty(this, 'ready', {
        get: function() {
            return this.images.length >= 2;
        }
    });

    Object.defineProperty(this, 'width', {
        get: function() {
            return width;
        }
    });

    Object.defineProperty(this, 'height', {
        get: function() {
            return height;
        }
    });

    Object.defineProperty(this, 'divide', {
        get: function() {
            return divide;
        },
        set: function(value) {
            if (value > 1) {
                value = (value / 100);
            }

            divide = value;
            this.draw();
        }
    });


    this.currentTX = 0.0;
    this.currentTY = 0.0;
    this.currentScale = 1.0;
    this.scaleFactor = 1.1;
}




TwoFace.prototype = {
    zoom: function(factor){
        var pt = this.ctx.transformedPoint(this.lastX,this.lastY);
        this.ctx.translate(pt.x,pt.y);
        // var factor = Math.pow(this.scaleFactor,clicks);
        // if(factor * this.currentScale < 1.0) {
        //     factor = 1.0;
        // }
        this.currentScale *= factor;
        $("#scale_label").text(float_format(this.currentScale*100,0)+" %");
        this.ctx.scale(factor,factor);
        this.ctx.translate(-pt.x,-pt.y);
        this.draw();
    },

    add: function(src) {
        var img = createImage(src, onload.bind(this));

        function onload(event) {
            this.images.push(img);

            if (this.ready) {
                this.draw();
            }
        }
    },

    draw: function() {
        if (!this.ready) {
            return;
        }

        var lastIndex = this.images.length - 1,
            before = this.images[lastIndex - 1],
            after = this.images[lastIndex];

        // Clear the entire canvas
        var p1 = this.ctx.transformedPoint(0,0);
        var p2 = this.ctx.transformedPoint(this.canvas.width,this.canvas.height);
        this.ctx.clearRect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y);

        this.drawImages(this.ctx, before, after);
        this.drawHandle(this.ctx);
    },

    drawImages: function(ctx, before, after) {
        var split = this.divide * this.width;
        split = this.ctx.transformedPoint(split, 0).x;


        ctx.mozImageSmoothingEnabled = false;
        ctx.webkitImageSmoothingEnabled = false;
        ctx.msImageSmoothingEnabled = false;
        ctx.imageSmoothingEnabled = false;
        ctx.drawImage(after, 0,0, this.width, this.height);
        ctx.drawImage(before, 0, 0, split, this.height, 0, 0, split, this.height);
    },

    drawHandle: function(ctx) {
        var split = this.divide * this.width;
        split = this.ctx.transformedPoint(split, 0).x;
        
        ctx.fillStyle = "rgb(220, 50, 50)";
        ctx.fillRect(split - 1, 0, 2, this.height);
    },

    mousedown: function(event) {
        if(!event.shiftKey) {
            var divide = event._x / this.width;
            this.divide = divide;
        }

        this.lastX = event.offsetX || (event.pageX - canvas.offsetLeft);
        this.lastY = event.offsetY || (event.pageY - canvas.offsetTop);
        this.dragStart = this.ctx.transformedPoint(this.lastX,this.lastY);
        this.dragged = false;
    },

    mousemove: function(event) {
        if (this.dragStart != null) {
            this.dragged = true;
            if(event.shiftKey) {
                console.log("drag with shift");
                this.lastX = event.offsetX || (event.pageX - canvas.offsetLeft);
                this.lastY = event.offsetY || (event.pageY - canvas.offsetTop);
                if (this.dragStart){
                    var pt = this.ctx.transformedPoint(this.lastX,this.lastY);
                    this.ctx.translate(pt.x-this.dragStart.x,pt.y-this.dragStart.y);
                    this.draw();
                }
            } else {
                var divide = event._x / this.width;
                this.divide = divide;
            }
        }
    },

    mouseup: function(event) {
        // var divide = event._x / this.width;
        // this.divide = divide;
        if(! this.dragged && event.shiftKey) {
            this.currentScale = 1.0;
            $("#scale_label").text(float_format(this.currentScale*100,0)+" %");
            this.ctx.setTransform(1,0,0,1,0,0);
            this.draw();
        }

        this.dragStart = null;
    },

    mousewheel: function(event) {
        var delta = event.wheelDelta ? event.wheelDelta/40 : event.detail ? -event.detail : 0;
        var factor = Math.pow(this.scaleFactor,delta);
        if (delta) this.zoom(factor);
        return event.preventDefault() && false;
    }
};




function createImage(src, onload) {
    var img = document.createElement('img');
    img.src = src;

    if (typeof onload == 'function') {
        img.addEventListener('load', onload);
    }

    return img;
}

// Adds ctx.getTransform() - returns an SVGMatrix
// Adds ctx.transformedPoint(x,y) - returns an SVGPoint
function trackTransforms(ctx){
    var svg = document.createElementNS("http://www.w3.org/2000/svg",'svg');
    var xform = svg.createSVGMatrix();
    ctx.getTransform = function(){ return xform; };
    
    var savedTransforms = [];
    var save = ctx.save;
    ctx.save = function(){
        savedTransforms.push(xform.translate(0,0));
        return save.call(ctx);
    };
    var restore = ctx.restore;
    ctx.restore = function(){
        xform = savedTransforms.pop();
        return restore.call(ctx);
    };

    var scale = ctx.scale;
    ctx.scale = function(sx,sy){
        xform = xform.scaleNonUniform(sx,sy);
        return scale.call(ctx,sx,sy);
    };
    var rotate = ctx.rotate;
    ctx.rotate = function(radians){
        xform = xform.rotate(radians*180/Math.PI);
        return rotate.call(ctx,radians);
    };
    var translate = ctx.translate;
    ctx.translate = function(dx,dy){
        xform = xform.translate(dx,dy);
        return translate.call(ctx,dx,dy);
    };
    var transform = ctx.transform;
    ctx.transform = function(a,b,c,d,e,f){
        var m2 = svg.createSVGMatrix();
        m2.a=a; m2.b=b; m2.c=c; m2.d=d; m2.e=e; m2.f=f;
        xform = xform.multiply(m2);
        return transform.call(ctx,a,b,c,d,e,f);
    };
    var setTransform = ctx.setTransform;
    ctx.setTransform = function(a,b,c,d,e,f){
        xform.a = a;
        xform.b = b;
        xform.c = c;
        xform.d = d;
        xform.e = e;
        xform.f = f;
        return setTransform.call(ctx,a,b,c,d,e,f);
    };
    var pt  = svg.createSVGPoint();
    ctx.transformedPoint = function(x,y){
        pt.x=x; pt.y=y;
        return pt.matrixTransform(xform.inverse());
    };
    ctx.inverseTransformedPoint = function(x,y){
        pt.x=x; pt.y=y;
        return pt.matrixTransform(xform);
    };
}


