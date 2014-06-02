/*global window*/
(function(){
    (function(canvas){
        var ctx = canvas.getContext("2d");
        ctx.strokeStyle = "black";

        function clearCanvas(){
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

        function randomColorWithAlpha(alpha){
            return [
                _.random(0,255),
                _.random(0,255),
                _.random(0,255),
                alpha
            ];
        }

        var rectSpec = {};
        var defaultRect = {
            color: [255,255,255,1],
            remaining: 0,
            duration: 1
        }


        var socket = new WebSocket('ws://127.0.0.1:8080');
        socket.onmessage = function(msg){
            var data = JSON.parse(msg.data);
            var note = data.note - 40;
            var duration = data.duration - 30;

            rectSpec[note] = {
                color: randomColorWithAlpha(1.0),
                duration: 2*duration,
                remaining: 2*duration
            }
        }

        function updateRectangles(diff){
            console.log(diff);
            _.each(rectSpec, function(e,key){
                e.remaining -= diff;
                if(e.remaining < 0){
                    e.remaining = 0;
                }
            });
        }
            
        function applyAlphaFactor(color,frac){
            return [color[0],color[1],color[2],color[3]*frac*3.0];
        }

        function buildRect(x,y,rectw,recth,count){
            var spec = rectSpec[count] || defaultRect;
            var scale = spec.scale, color = spec.color;

            var frac = spec.remaining / spec.duration;

            scale *= frac;
            color = applyAlphaFactor(color, frac);

            return {
                x: x,
                y: y,
                width: rectw,
                height: recth,
                style: "rgba(" + color.join(",") + ")"
            }
        }

        function rectanglePositions(rectw,recth){
            var rects = [];
            for(var i = 0, count = 0;;i++){
                if((i+1)*recth > canvas.height){
                    break;
                }
                for(var j = 0;; j++){
                    if((j+1)*rectw > canvas.width){
                        break;
                    }
                    rects.push({
                        x: j*rectw,
                        y: i*recth,
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
            var time = window.performance.now();
            return function(){
                var newTime = window.performance.now();
                var prevTime = time;
                time = newTime;
                return newTime-prevTime;
            }
        }

        var timeDiff = diff();
        function render(){
            requestAnimationFrame(render);

            var diff = timeDiff();
            updateRectangles(diff);

            clearCanvas();
            drawRectangles(100,100);
        }

        render();
    }($("#wrapper canvas")[0]));
}());
