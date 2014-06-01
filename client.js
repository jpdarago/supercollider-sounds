/*global window*/
(function(){
    (function(canvas){
        var ctx = canvas.getContext("2d");
        ctx.strokeStyle = "black";

        function clearCanvas(){
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

        var rectSpec = {
            10: { 
                time: 40,
                scale: 0.4,
                color: [255,0,0],
            }
        };
        var defaultRect = {
            scale: 0.0,
            color: [255,255,255]
        }

        function updateRectangles(diff){

        }

        function buildRect(x,y,rectw,recth,count){
            var spec = rectSpec[count] || defaultRect;
            var scale = spec.scale, color = spec.color;
            return {
                x: x-(scale/2)*rectw,
                y: y-(scale/2)*recth,
                width: (1+scale)*rectw,
                height: (1+scale)*recth,
                style: "rgb(" + color.join(",") + ")"
            }
        }

        function rectanglePositions(rectw,recth){
            var rects = [];
            for(var i = 0, count = 0;;i++){
                if((i+1)*rectw > canvas.width){
                    break;
                }
                for(var j = 0;; j++){
                    if((j+1)*recth > canvas.height){
                        break;
                    }
                    rects.push({
                        x: i*rectw,
                        y: j*recth,
                        index: count
                    });
                    count++;
                }
            }
            return rects;
        }

        function drawRectangles(rectw,recth){
            var rects = rectanglePositions(rectw,recth);
            var parts = _.partition(rects,function(e){
                return  rectSpec[e.index] !== undefined &&
                        rectSpec[e.index].scale > 0;
            });
            var order = parts[1].concat(parts[0]);
            _.each(order, function(rect){
                var spec = buildRect(rect.x,rect.y,rectw,recth,rect.index);
                ctx.fillStyle = spec.style;
                ctx.fillRect(spec.x,spec.y,spec.width,spec.height);
                ctx.strokeRect(spec.x,spec.y,spec.width,spec.height);
            });
            ctx.stroke();
        }

        function diff(timer){
            var time = timer();
            return function(){
                var newTime = timer();
                var prevTime = time;
                time = newTime;
                return newTime-prevTime;
            }
        }

        var timeDiff = diff(window.performance.now);
        function render(){
            requestAnimationFrame(render);

            var diff = timeDiff();
            updateAllRectangles(diff);

            clearCanvas();
            drawRectangles(80,80);
        }

        render();
    }($("#wrapper canvas")[0]));
}());
