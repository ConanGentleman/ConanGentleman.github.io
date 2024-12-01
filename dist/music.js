const ap = new APlayer({
    container: document.getElementById('aplayer'),
    fixed: false,
    mini: false,//迷你模式
    autoplay: true, //自动播放
    loop: 'all', //音频循环播放, 可选值: 'all'全部循环, 'one'单曲循环, 'none'不循环
    order: 'list', //音频循环顺序, 可选值: 'list'列表循环, 'random'随机循环
    audio: [
      {
        name: '溯（钢琴版）',
        artist: '柳轻颂',
        url: 'http://music.163.com/song/media/outer/url?id=1433584979.mp3',
        cover: 'http://p1.music.126.net/qX7knUIlpmbJ34UBzCCS6w==/109951164802366812.jpg?param=130y130',
      },
      {
        name: "夢灯籠",
        artist: 'RADWIMPS',
        url: '/images/夢灯籠.mp3',
        cover: 'http://p2.music.126.net/sSxbRt9RpC6s_MaewyDJfA==/18597139672292692.jpg?param=130y130',
      },
    ]
  });
