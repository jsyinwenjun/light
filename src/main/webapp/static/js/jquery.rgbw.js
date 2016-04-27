/**
 * Version: 0.1
 * 
 * Copyright (c) 2016 Rail
 */


;(function($, window, document,undefined) {
	var src = $("script").last().attr("src")
    //定义RGBW的构造函数
    var RGBW = function(ele, opt) {
		var that = this;
        this.$element = ele,
        this.defaults = {
            'start':function(color){
            	
            },
            'change':function(color) {
            	
            },
            'release':function(color) {
            	
            },
            width: this.$element.width()
        },
        this.options = $.extend({}, this.defaults, opt),
        this.x = 0,
        this.y = 0,
        this.PI3 = Math.PI / 3,
        this.touchX,
        this.touchY,
        this.angle,
        this.radius,
        
        
        this.centerX,
        this.centerY,
        this.maxRadius,
        
        this.ctx,
        
        this.color,
        
        this.touchstart = function(e) {
        	var offset = that.$element.offset();
        	that.x = offset.left;
        	that.y = offset.top;
        	this.color = that.getRGBWFromEvent(e);
        	that.options.start(this.color);
        },
        this.touchmove = function(e) {
        	this.color = that.getRGBWFromEvent(e);
        	that.options.change(this.color);
        },
        this.touchend = function(e) {
        	that.options.release(this.color);
        },
        this.getRGBWFromEvent = function(e) {
        	this.touchX = e.originalEvent.touches[0].pageX - this.x;
        	this.touchY = e.originalEvent.touches[0].pageY - this.y;
        	
        	var y = this.touchY - this.centerY;
        	var x = this.touchX - this.centerX;
        	var red = 0, green = 0, blue = 0, white = 0;
        	
        	this.angle = Math.atan2(y, x);
        	if (this.angle > 0 && this.angle < this.PI3 * 2) {
        		blue = this.angle / this.PI3 / 2;
        		red = 1 - blue;
        	}else if (this.angle > -this.PI3 * 2 && this.angle < 0) {
        		green = Math.abs(this.angle) / this.PI3 / 2;
        		red = 1 - green;
        	}else if (this.angle > this.PI3 * 2) {
        		green = (this.angle - this.PI3 * 2) / this.PI3 / 2;
        		blue = 1 - green;
        	}else if (this.angle < -this.PI3 * 2) {
        		green = (this.angle + Math.PI + this.PI3) / this.PI3 / 2;
        		blue = 1 - green;
        	}
        	var radius = Math.pow((x * x + y * y), 0.5);
        	if (radius > this.maxRadius) {
        		radius = this.maxRadius;
        	}
        	this.radius = radius;
        	this.redraw();
        	
        	var white = this.radius / this.maxRadius;
        	
        	return {
        		'red':this.toInt8(red * white),
        		'green':this.toInt8(green * white),
        		'blue':this.toInt8(blue * white),
        		'white':this.toInt8(1 - white)
        	}
        },
        this.toInt8 = function(value) {
        	return Math.round(value * 255);
        },
        
        this.redraw = function() {
        	var x = Math.cos(this.angle) * this.radius + this.centerX;
        	var y = Math.sin(this.angle) * this.radius + this.centerY;
        	
        	this.ctx.clearRect(0, 0, this.options.width, this.options.width);
        	this.ctx.beginPath();
        	this.ctx.arc(x, y, 8, 0, Math.PI * 2, false);
        	this.ctx.closePath();
        	this.ctx.fillStyle = "#FFF";
        	
        	this.ctx.fill();
        	this.ctx.strokeStyle = "#000";
        	this.ctx.stroke();
        }
    }
    //定义RGBW的方法
    RGBW.prototype = {
    		generate: function() {
    			var screenWidth = $(window).width();
    			this.$element.attr("height", this.options.width);
    			this.$element.attr("width", this.options.width);
    			
    			this.$element.css({
                    'position': 'absolute',
                    'top': 0,
                    'left': screenWidth / 2 - this.options.width / 2
                });
    			this.ctx = this.$element[0].getContext("2d");
    			
    			this.centerX = this.options.width / 2;
    			this.centerY = this.options.width / 2;
    			
    			this.maxRadius = this.options.width / 2 - 8;
    			
    			$img = $("<img></img>");
    			$img.attr("src", src.substring(0, src.lastIndexOf("/") + 1) + "rgbw.png");
    			$img.css({
                    'width': this.options.width,
                    'height': this.options.width
                });
    			
    			this.$element.before($img)
    			
    			this.$element.bind("touchstart", this.touchstart);
    			this.$element.bind("touchmove", this.touchmove);
    			this.$element.bind("touchend", this.touchend);
    			
        }
    	
    }
    //在插件中使用RGBW对象
    $.fn.rgbw = function(options) {
        //创建RGBW的实体
        var rgbw = new RGBW(this, options);
        //调用其方法
        return rgbw.generate();
    }
})(jQuery, window, document);