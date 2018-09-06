/**
* Listのsortメソッドでカスタムの並び替えを行う
* @see https://developer.salesforce.com/docs/atlas.ja-jp.214.0.apexcode.meta/apexcode/apex_comparable.htm
*/
public with sharing class zz_sample_ComparableObject implements Comparable {
    private User u;
    private userNameLength {get u.Name.length();}
    public zz_sample_ComparableObject(User pUser) {
        this.u = pUser
    }

    public Integer compareTo( Object compareTo ) {
        zz_sample_ComparableObject compareToOrg =  ( zz_sample_ComparableObject ) compareTo;
        if ( userNameLength == compareToOrg.userNameLength ) { return 0; }
        if ( userNameLength >  compareToOrg.userNameLength ) { return 1; }
        return -1;
    }
}
