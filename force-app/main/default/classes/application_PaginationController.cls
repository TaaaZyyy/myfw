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


    /** 任意のページまでページを進める */
    protected void goToPage( Integer wantToGo ) {
        if ( this.ssc == null ) { return; }
        this.ssc.first();
        for ( Integer i = 1; i < wantToGo; i++ ) {
            if ( this.ssc.getHasNext() ) { this.ssc.next(); }
        }
        init();
    }
}
