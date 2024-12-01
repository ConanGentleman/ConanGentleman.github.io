{% macro render(display_toc) %}
  <div class="toggle sidebar-toggle">
    <span class="toggle-line toggle-line-first"></span>
    <span class="toggle-line toggle-line-middle"></span>
    <span class="toggle-line toggle-line-last"></span>
  </div>

  <aside class="sidebar">
    <div class="sidebar-inner">

      {%- set display_toc = page.toc.enable and display_toc %}
      {%- if display_toc %}
        {%- set toc = toc(page.content, { class: "nav", list_number: page.toc.number, max_depth: page.toc.max_depth }) %}
        {%- set display_toc = toc.length > 1 and display_toc %}
      {%- endif %}

      <ul class="sidebar-nav motion-element">
        <li class="sidebar-nav-toc">
          {{ __('sidebar.toc') }}
        </li>
        <li class="sidebar-nav-overview">
          {{ __('sidebar.overview') }}
        </li>
      </ul>

      <!--noindex-->
      <div class="post-toc-wrap sidebar-panel">
        {%- if display_toc %}
          <div class="post-toc motion-element">{{ toc }}</div>
        {%- endif %}
      </div>
      <!--/noindex-->

      <div class="site-overview-wrap sidebar-panel">
        {{ partial('_partials/sidebar/site-overview.swig', {}, {cache: theme.cache.enable}) }}

        {{- next_inject('sidebar') }}
      </div>


<div class="twopeople">
        <div class="container" style="height:200px;">
            <canvas class="illo" width="800" height="800" style="max-width: 200px; max-height: 200px; touch-action: none; width: 640px; height: 640px;"></canvas>
        </div>
        <script src="https://cdn.jsdelivr.net/gh/Justlovesmile/CDN/js/twopeople1.js"></script>
        <script src="https://cdn.jsdelivr.net/gh/Justlovesmile/CDN/js/zdog.dist.js"></script>
        <script id="rendered-js" src="https://cdn.jsdelivr.net/gh/Justlovesmile/CDN/js/twopeople.js"></script>
        <style>
            .twopeople{
                margin: 0;
                align-items: center;
                justify-content: center;
                text-align: center;
            }
            canvas {
                display: block;
                margin: 0 auto;
                cursor: move;
            }
        </style>
      </div>
<!-- 外链播放器 溯（钢琴版）-->
<!-- <iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=330 height=86 src="//music.163.com/outchain/player?type=2&id=1433584979&auto=1&height=66"></iframe> -->
<!-- 不使用上面的外链播放器了 改用下面的Aplayer -->
<link rel="stylesheet" href="/dist/APlayer.min.css">
<div id="aplayer"></div>
<script type="text/javascript" src="/dist/APlayer.min.js"></script>
<script type="text/javascript" src="/dist/music.js"></script>
<!-- 改用Aplayer end -->

      {%- if theme.back2top.enable and theme.back2top.sidebar %}
        <div class="back-to-top animated" role="button" aria-label="{{ __('accessibility.back_to_top') }}">
          <i class="fa fa-arrow-up"></i>
          <span>0%</span>
        </div>
      {%- endif %}

    </div>
  </aside>
  <div id="sidebar-dimmer"></div>

{% endmacro %}
