<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Onni.User.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Hero Section Begin -->
    <section class="hero">
        <div class="container">
            <div class="row">
                <div class="col-lg-3">
                    <div class="hero__categories">
                        <div class="hero__categories__all">
                            <i class="fa fa-bars"></i>
                            <span>Категории</span>
                        </div>
                        <ul>
                            <asp:Repeater ID="rHeroCategories" runat="server">
                                <ItemTemplate>
                                    <li>
                                        <a href='Catalog.aspx?cat=<%# Eval("CategoryId") %>'><%# Eval("Name") %></a>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-9">
                    <!-- Поиск -->
                    <div class="hero__search__form mb-3">
                        <asp:Panel runat="server" DefaultButton="btnSearch" CssClass="d-flex w-100">
                            <asp:TextBox ID="txtSearch" runat="server"
                                CssClass="form-control border search-style"
                                placeholder="Что вы ищете?" />
                            <asp:Button ID="btnSearch" runat="server"
                                Text="SEARCH"
                                CssClass="site-btn px-4 fw-bold"
                                OnClick="btnSearch_Click" />
                        </asp:Panel>
                    </div>
                    <!-- Баннер (теперь он занимает всю ширину, под поиском) -->
                    <div class="hero__item set-bg w-100" data-setbg="../TemplateFiles/img/banner/banner1.jpg" style="height: 400px;">
                        <div class="hero__text text-left p-4">
                            <span>УХОДОВАЯ КОСМЕТИКА<br />
                                Натуральные формулы<br />
                                100% органический состав<br />
                                быстрая доставка<br /><br />
                            </span>
                            <a href="Catalog.aspx" class="primary-btn">КУПИТЬ СЕЙЧАС</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Hero Section End -->
    <!-- Categories Section Begin -->
    <section class="categories">
        <div class="container">
            <div class="row">
                <div class="categories__slider owl-carousel">
                    <div class="col-lg-3">
                        <div class="categories__item set-bg" data-setbg="../TemplateFiles/img/categories/cat-1.jpg">
                            <h5><a href="#">Fresh Fruit</a></h5>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="categories__item set-bg" data-setbg="../TemplateFiles/img/categories/cat-2.jpg">
                            <h5><a href="#">Dried Fruit</a></h5>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="categories__item set-bg" data-setbg="../TemplateFiles/img/categories/cat-3.jpg">
                            <h5><a href="#">Vegetables</a></h5>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="categories__item set-bg" data-setbg="../TemplateFiles/img/categories/cat-4.jpg">
                            <h5><a href="#">drink fruits</a></h5>
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="categories__item set-bg" data-setbg="../TemplateFiles/img/categories/cat-5.jpg">
                            <h5><a href="#">drink fruits</a></h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Categories Section End -->
    <!-- Blog Section Begin -->
    <section class="from-blog spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="section-title from-blog__title">
                        <h2>Блог Onni</h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 col-md-4 col-sm-6">
                    <div class="blog__item">
                        <div class="blog__item__pic">
                            <img src="../TemplateFiles/img/blog/1.jpg" alt="">
                        </div>
                        <div class="blog__item__text">
                            <ul>
                                <li><i class="fa fa-calendar-o"></i>Май 2025</li>
                                <li><i class="fa fa-comment-o"></i>12</li>
                            </ul>
                            <h5><a href="#">Как выбрать уход по типу кожи</a></h5>
                            <p>Узнайте, как правильно подбирать косметику в зависимости от типа кожи — жирной, сухой или комбинированной. Советы от экспертов и подборка средств. </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-6">
                    <div class="blog__item">
                        <div class="blog__item__pic">
                            <img src="../TemplateFiles/img/blog/2.jpg" alt="">
                        </div>
                        <div class="blog__item__text">
                            <ul>
                                <li><i class="fa fa-calendar-o"></i>Май 2025</li>
                                <li><i class="fa fa-comment-o"></i>4</li>
                            </ul>
                            <h5><a href="#">Утренний уход: 5 простых шага</a></h5>
                            <p>Как быстро и эффективно подготовить кожу к дню? Рассказываем про базовый утренний ритуал и рекомендуем продукты. </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-4 col-sm-6">
                    <div class="blog__item">
                        <div class="blog__item__pic">
                            <img src="../TemplateFiles/img/blog/3.jpg" alt="">
                        </div>
                        <div class="blog__item__text">
                            <ul>
                                <li><i class="fa fa-calendar-o"></i>Май 2025</li>
                                <li><i class="fa fa-comment-o"></i>7</li>
                            </ul>
                            <h5><a href="#">Чем отличается SPF 30 от SPF 50?</a></h5>
                            <p>Объясняем простым языком, как работает защита от солнца и что выбрать в зависимости от времени года. </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Blog Section End -->
</asp:Content>
