(function($) {
    $(function() {
        var key              = "input your vendor key here",
            resolution       = Cookies.get("resolution") || "480p",
            maxFrameRate     = Number(Cookies.get("maxFrameRate") || 15),
            maxBitRate       = Number(Cookies.get("maxBitRate") || 750),
            channel          = Cookies.get("roomName"),
            client           = AgoraRTC.Client({}),
            remoteStreamList = [],
            localStream;
        var hostParams = {
            key        : 'input your vendor key here',
            cname      : channel,
            role       : 'host',
            width      : 1024,
            height     : 768,
            container  : "wbHost"
        };
        /* Call AgoraWhiteBoardApi */
        Agora.Whiteboard.join(hostParams);

        if (isMobile()) {
            $("#videoContainer").css({
                width: "720px"
            });
        }

        /* Joining channel */
        (function initAgoraRTC() {
            client.init(key, function () {
                console.log("AgoraRTC client initialized");
                client.join(channel, undefined, function(uid) {
                    console.log("User " + uid + " join channel successfully");
                    console.log("Timestamp: " + Date.now());
                    localStream = initLocalStream(uid);
                });
            });
        }());

        subscribeStreamEvents();

        // Utility function begin
        function subscribeStreamEvents() {
            client.on('stream-added', function (evt) {
                var stream = evt.stream;
                console.log("New stream added: " + stream.getId());
                console.log("Timestamp: " + Date.now());
                client.subscribe(stream, function (err) {
                    console.log("Subscribe stream failed", err);
                });
            });

            client.on('peer-leave', function(evt) {
                console.log("Peer has left: " + evt.uid);
                console.log("Timestamp: " + Date.now());
                showStreamOnPeerLeave(evt.uid);
            });

            client.on('stream-subscribed', function (evt) {
                var stream = evt.stream;
                console.log("Got stream-subscribed event");
                console.log("Timestamp: " + Date.now());
                console.log("Subscribe remote stream successfully: " + stream.getId());
                showStreamOnPeerAdded(stream);
            });

            client.on("stream-removed", function(evt) {
                var stream = evt.stream;
                console.log("Stream removed: " + evt.stream.getId());
                console.log("Timestamp: " + Date.now());
                showStreamOnPeerLeave(evt.stream.getId());
            });
        }

        function showStreamOnPeerLeave(streamId) {
            removeStreamFromList(Number(streamId));
            removeElementIfExist('agora-video-parent', streamId);
            if (remoteStreamList.size === 0) {
                $("#videoContainer").empty();
            }
        }

        function showStreamOnPeerAdded(stream) {
            addToRemoteStreamList(stream);
            removeElementIfExist('agora-video-parent', stream.getId());
            displayStream('agora-video-parent', stream, 160, 120, 'host-stream');
        }

        function initLocalStream(uid, callback) {
            if(localStream) {
                // local stream exist already
                client.unpublish(localStream, function(err) {
                    console.log("Unpublish failed with error: ", err);
                });
                localStream.close();
            }
            localStream = AgoraRTC.createStream({
                streamID: uid,
                audio: true,
                video: true,
                screen: false
            });
            localStream.setVideoResolution(resolution);
            localStream.setVideoFrameRate([maxFrameRate, maxFrameRate]);
            localStream.setVideoBitRate([maxBitRate, maxBitRate]);

            localStream.init(function() {
                console.log("Get UserMedia successfully");
                displayStream('agora-video-parent', localStream, 160, 120, 'host-local-stream');

                client.publish(localStream, function (err) {
                    console.log("Timestamp: " + Date.now());
                    console.log("Publish local stream error: " + err);
                });
                client.on('stream-published');
            }, function(err) {
                console.log("Local stream init failed.", err);
                //displayInfo("Please check camera or audio devices on your computer, then try again.");
                //$(".info").append("<div class='back'><a href='index.html'>Back</a></div>");
            });
            return localStream;
        }

        function addToRemoteStreamList(stream) {
            if (stream) {
                remoteStreamList.push({
                    id: stream.getId(),
                    stream: stream
                });
            }
        }

        function removeStreamFromList(id) {
            var index, tmp;
            for (index = 0; index < remoteStreamList.length; index += 1) {
                var tmp = remoteStreamList[index];
                if (tmp.id === id) {
                    var toRemove = remoteStreamList.splice(index, 1);
                    if (toRemove.length === 1) {
                        //delete toRemove[1];
                        console.log("stream stopping..." + toRemove[0].stream.getId());
                        toRemove[0].stream.stop();
                    }
                }
            }
        }

        function removeElementIfExist(tagId, uid) {
            $("#" + tagId + uid).remove();
        }

        function displayStream(tagId, stream, width, height, className) {
            // cleanup, if network connection interrupted, user cannot receive any events.
            // after reconnecting, the same node id is reused,
            // so remove html node with same id if exist.
            removeElementIfExist(tagId, stream.getId());

            var $container = $("#videoContainer");

            $container.append('<div id="' + tagId + stream.getId() + '" class="' + className + '" data-stream-id="' + stream.getId() + '"></div>');

            $("#" + tagId + stream.getId()).css({
                width: String(width) + "px",
                height: String(height)+ "px"
            });
            stream.play(tagId + stream.getId(), "images");
        }

        function isMobile() {
            var isMobile = false; //initiate as false
            // device detection
            if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent)
               || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4)))
           isMobile = true;
           return isMobile;
        }
        // Utility functions end
    });
}(jQuery));
