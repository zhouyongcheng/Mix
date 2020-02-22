## 用一个表中的值去更新另外的表.
> mysql

```sql
update emp e set (e.sal, e.comm) = (select ns.sal, ns.sal*0.5 from new_sal ns where ns.empno = e.empno)
where exists (select null from new_sal where ns.empno = e.empno)
```

> sqlserver

```sql
update emp e
    set e.sal = ns.sal,
          e.comm = ns.sal*.05
    from emp e, new_sal ns
    where e.empno = ns.empno
```

## 选择插入记录
```sql
insert into emp (name,  age, sal)  select name, age, new_sal from new_emp where deptno = 10
```