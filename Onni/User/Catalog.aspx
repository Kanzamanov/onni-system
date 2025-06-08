<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Catalog.aspx.cs" Inherits="Onni.User.Catalog" %>

<%@ Import Namespace="Onni" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Featured Section Begin -->
    <section class="featured spad">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="section-title">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb bg-white px-0">
                                <li class="breadcrumb-item"><a href="Default.aspx">Главная</a></li>
                                <li class="breadcrumb-item"><a href="Catalog.aspx">Товары</a></li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    <asp:Label ID="lblBreadcrumb" runat="server" Text="Фильтр"></asp:Label>
                                </li>
                            </ol>
                        </nav>

                        <div class="align-self-end text-right">
                            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                        </div>
                        <h2>
                            <asp:Label ID="lblTitle" runat="server" Text="Товары"></asp:Label></h2>
                    </div>
                </div>
            </div>
            <div class="row featured__filter">
                <asp:Repeater ID="rProducts" runat="server" OnItemCommand="rProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-2 px-2 mix <%# Regex.Replace(Eval("CategoryName").ToString().ToLower(), @"\s+", "") %>">
                            <div class="featured__item position-relative">

                                <div class="featured__item__pic set-bg" data-setbg="<%# Utils.GetImageUrl(Eval("ImageUrl")) %>">
                                    <ul class="featured__item__pic__hover">
                                        <li>
                                            <!-- Добавление в корзину -->
                                            <asp:LinkButton runat="server" ID="lbAddToCart"
                                                CssClass="text-black position-relative zindex-dropdown"
                                                CommandName="addToCart"
                                                CommandArgument='<%# Eval("ProductId") %>'>
                                <i class="fa fa-shopping-cart"></i>
                                            </asp:LinkButton>
                                        </li>
                                    </ul>
                                </div>

                                <div class="featured__item__text">
                                    <h6 class="product-name">
                                        <a href='<%# "ProductDetails.aspx?id=" + Eval("ProductId") %>'>
                                            <%# Eval("Name") %>
                                        </a>
                                    </h6>
                                    <h5><%# Eval("Price", "{0:0}") %> сом</h5>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <!-- Центрированный текст, если нет данных -->
                <div class="col-12">
                    <asp:Panel ID="pnlNoData" runat="server" Visible="false">
                        <div class="text-center py-5">
                            <h5 class="text-muted">Нет доступных товаров.</h5>
                        </div>
                    </asp:Panel>
                </div>
            </div>
    </section>
    <!-- Featured Section End -->
</asp:Content>
