<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Onni.User.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- About Section Begin -->
    <section class="about spad">
        <div class="container">
            <div class="row justify-content-center mb-5">
                <div class="col-lg-8 text-center">
                    <div class="section-title">
                        <h2>О магазине Onni</h2>
                    </div>
                    <p>Натуральный уход, которому можно доверять</p>
                </div>
            </div>

            <!-- Картинка + текст -->
            <div class="row gx-0 align-items-center">
                <!-- Картинка -->
                <div class="col-md-5">
                    <img src="../TemplateFiles/img/banner/about.jpg" alt="О нас"
                         class="img-fluid rounded shadow-sm w-100" />
                </div>

                <!-- Текст -->
                <div class="col-md-7 ps-md-3">
                    <h4>Мы верим в силу природы</h4>
                    <p>
                        Onni — это не просто магазин косметики. Это пространство, где красота сочетается с заботой, а качество — с натуральностью.
                        Мы отбираем только лучшие продукты по уходу за кожей и волосами, вдохновляясь чистотой природы и потребностями наших клиентов.
                    </p>
                    <p>
                        В нашем ассортименте вы найдете проверенные бренды, органические формулы, веганские средства и решения для всех типов кожи.
                        Мы заботимся о вашей уверенности, здоровье и внутреннем балансе.
                    </p>
                    <ul class="list-unstyled mt-3">
                        <li><i class="fa fa-check text-success me-2"></i>Натуральные и сертифицированные составы</li>
                        <li><i class="fa fa-check text-success me-2"></i>Поддержка локальных брендов</li>
                        <li><i class="fa fa-check text-success me-2"></i>Бережная доставка по Кыргызстану</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>
    <!-- About Section End -->
</asp:Content>
