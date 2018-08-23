public abstract with sharing class application_PaginationController {
    public application_PaginationController() {}

// ====================================
//  VFコントローラメソッド
// ====================================
    abstract PageReference doInit();
    abstract PageReference doSearch();
    abstract PageReference doSave();
    public Pagereference dummy() { return null; }


// ====================================
//  ページネーション
// ====================================
    protected Integer rowsPerPageNum = 100; // 1ページあたりの表示件数
    protected ApexPages.StandardSetController ssc { get; set; }
    public void    doFirst()        { ssc.first();    init(); }
    public void    doPrevious()     { ssc.previous(); init(); }
    public void    doNext()         { ssc.next();     init(); }
    public void    doLast()         { ssc.last();     init(); }
    public Boolean getHasNext()     { return ( this.ssc != null   ) ? ssc.getHasNext()     : false; }
    public Boolean getHasPrevious() { return ( this.ssc != null   ) ? ssc.getHasPrevious() : false; }
    public Integer getTotalSize()   { return ( this.ssc != null   ) ? ssc.getResultSize() : 0; } // 検索結果の件数
    public Integer getStartIndex()  { return ( getTotalSize() > 0 ) ? ssc.getPageSize() * ( getPageNumber() - 1 ) + 1 : 0; } // 現在のページの最初のレコードのインデックス
    public Integer getEndIndex()    { return ( getTotalSize() > 0 ) ? ( ( ssc.getHasNext() ) ? getStartIndex() + ssc.getPageSize() - 1 : ssc.getResultSize()) : 0; }
    public Integer getPageNumber()  { return ( this.ssc != null   ) ? ssc.getPageNumber() : 0; } // 現在のページ
    public Integer getTotalPages()  { return ( this.ssc != null   ) ? ( (Integer) System.Math.ceil(ssc.getResultSize() / (Decimal) ssc.getPageSize()) ) : 0; } // 合計ページ


    /** ページ表示・切替えに伴う画面の初期化 */
    protected virtual void init(){}


    /** StandardSetController の初期化 */
    protected void setSsc(DA_QueryConditionContainer queryCondition) {
        ApexPages.StandardSetController tmpSsc = new ApexPages.StandardSetController( dao.getQueryLocator( queryCondition ) );
        tmpSsc.setPageSize( rowsPerPageNum );
        this.ssc = tmpSsc;
    }



// ====================================
//  ダイレクトリンク
// ====================================
    /** ページネーションの直接リンクの表示個数（現在のページを含む） */
    private final Integer MAX_DISP_PAGE = 7;


    /** 任意のページまでページを進める */
    protected void goToPage( Integer wantToGo ) {
        if ( this.ssc == null ) { return; }
        this.ssc.first();
        for ( Integer i = 1; i < wantToGo; i++ ) {
            if ( this.ssc.getHasNext() ) { this.ssc.next(); }
        }
        init();
    }


    /** ページネーションの直接リンクの数値リスト */
    public List<Integer> getPageNumsForLink() {
        Integer firstPageNum;
        Integer lastPageNum;

        if (getTotalPages() <= MAX_DISP_PAGE) {
            // ① 全ページ表示
            firstPageNum = 1;
            lastPageNum = getTotalPages();

        } else if ( (getPageNumber() - (MAX_DISP_PAGE / 2)) < 1) {
            // ② 1ページ目を含んで表示
            firstPageNum = 1;
            lastPageNum = MAX_DISP_PAGE;


        } else if ( (getPageNumber() + (MAX_DISP_PAGE / 2) > MAX_DISP_PAGE) ) {
            // ③ 最後のページを含んで表示
            firstPageNum = getTotalPages() - MAX_DISP_PAGE + 1;
            lastPageNum = getTotalPages();

        } else {
            // ④ 現在のページを中心にして表示
            firstPageNum = getPageNumber() - (MAX_DISP_PAGE / 2);
            lastPageNum = getPageNumber() + (MAX_DISP_PAGE / 2);
        }

        List<Integer> pageNumsForLink = new List<Integer>();
        for (Integer i = firstPageNum; i <= lastPageNum; i++) {
            pageNumsForLink.add(i);
        }
        return pageNumsForLink;
    }
}
